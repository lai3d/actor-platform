package im.actor.server.dialog

import java.time.Instant

import akka.actor.Status
import akka.pattern.pipe
import im.actor.server.cqrs.{ Event, Processor }
import im.actor.server.db.DbExtension
import im.actor.server.model.DialogObsolete
import im.actor.server.persist.dialog.DialogRepo

trait DialogRootMigration extends Processor[DialogRootState] {

  import DialogRootEvents._
  import context.dispatcher

  private case class CreateEvents(models: Seq[DialogObsolete])

  val userId: Int
  private val db = DbExtension(context.system).db
  private var needMigrate = true

  override def afterCommit(e: Event): Unit = e match {
    case Initialized(_) ⇒ needMigrate = false
    case _              ⇒
  }

  override protected def onRecoveryCompleted(): Unit = {
    super.onRecoveryCompleted()
    if (needMigrate)
      migrate()
  }

  private def migrating: Receive = {
    case CreateEvents(models) ⇒
      createEvents(models) {
        unstashAll()
        context become receiveCommand
      }
    case Status.Failure(e) ⇒
      log.error(e, "Failed to migrate")
      throw e
    case _ ⇒ stash()
  }

  private def migrate(): Unit = {
    context.become(migrating)

    (for {
      models ← db.run(DialogRepo.fetchDialogs(userId))
    } yield CreateEvents(models)) pipeTo self
  }

  private def createEvents(models: Seq[DialogObsolete])(onComplete: ⇒ Unit): Unit = {
    val created = models map { dialog ⇒
      Created(Instant.ofEpochMilli(dialog.createdAt.getMillis), Some(dialog.peer))
    }

    val archived = models.view.filter(_.archivedAt.isDefined) map { dialog ⇒
      Archived(Instant.ofEpochMilli(dialog.archivedAt.get.getMillis), Some(dialog.peer))
    }

    var ts = Instant.now()
    val favourited = models.view.filter(_.isFavourite) map { dialog ⇒
      ts = ts.plusMillis(1)
      Favourited(ts, Some(dialog.peer))
    }

    persistAll(Initialized(Instant.now()) +: (created ++ archived ++ favourited).toList) { _ ⇒
      onComplete
    }
  }
}
