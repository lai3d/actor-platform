import _ from 'lodash';

import React from 'react';

import { PeerTypes } from 'constants/ActorAppConstants';

import PeerUtils from 'utils/PeerUtils';

import MessagesSection from 'components/dialog/MessagesSection.react';
import TypingSection from 'components/dialog/TypingSection.react';
import ComposeSection from 'components/dialog/ComposeSection.react';
import ToolbarSection from 'components/ToolbarSection.react';
import ActivitySection from 'components/ActivitySection.react';
import ConnectionState from 'components/common/ConnectionState.react';

import DialogStore from 'stores/DialogStore';
import MessageStore from 'stores/MessageStore';
import GroupStore from 'stores/GroupStore';

import DialogActionCreators from 'actions/DialogActionCreators';

// On which scrollTop value start loading older messages
const LoadMessagesScrollTop = 100;

const initialRenderMessagesCount = 20;
const renderMessagesStep = 20;

let renderMessagesCount = initialRenderMessagesCount;

let lastPeer = null;
let lastScrolledFromBottom = 0;

const getStateFromStores = () => {
  const messages = MessageStore.getAll();
  let messagesToRender;


  if (messages.length > renderMessagesCount) {
    messagesToRender = messages.slice(messages.length - renderMessagesCount);
  } else {
    messagesToRender = messages;
  }

  return {
    peer: DialogStore.getSelectedDialogPeer(),
    messages: messages,
    messagesToRender: messagesToRender
  };
};

class DialogSection extends React.Component {
  constructor(props) {
    super(props);

    this.state = getStateFromStores();

    DialogStore.addSelectListener(this.onSelectedDialogChange);
    MessageStore.addChangeListener(this.onMessagesChange);
  }

  componentWillUnmount() {
    DialogStore.removeSelectListener(this.onSelectedDialogChange);
    MessageStore.removeChangeListener(this.onMessagesChange);
  }

  componentDidUpdate() {
    this.fixScroll();
    this.loadMessagesByScroll();
  }

  render() {
    const peer = this.state.peer;

    let mainContent;

    if (peer) {
      let isMember = true,
          memberArea;

      if (peer.type === PeerTypes.GROUP) {
        const group = GroupStore.getGroup(peer.id);
        isMember = DialogStore.isGroupMember(group);
      }

      if (isMember) {
        memberArea = (
          <div>
            <TypingSection/>
            <ComposeSection peer={peer}/>
          </div>
        );
      } else {
        memberArea = (
          <section className="compose compose--disabled row center-xs middle-xs">
            <h3>You are not a member</h3>
          </section>
        );
      }

      mainContent = (
        <section className="dialog" onScroll={this.loadMessagesByScroll}>
          <ConnectionState/>

          <div className="messages">
            <MessagesSection messages={this.state.messagesToRender}
                             peer={peer}
                             ref="MessagesSection"/>

          </div>

          {memberArea}
        </section>
      );
    } else {
      mainContent = (
        <section className="dialog dialog--empty row center-xs middle-xs">
          <ConnectionState/>
          <h2>Select dialog or start a new one.</h2>
        </section>
      );
    }

    return (
      <section className="main">
        <ToolbarSection/>

        <div className="flexrow">
          {mainContent}
          <ActivitySection/>
        </div>
      </section>
    );
  }

  fixScroll = () => {
    if (lastPeer !== null) {
      let node = React.findDOMNode(this.refs.MessagesSection);
      node.scrollTop = node.scrollHeight - lastScrolledFromBottom;
    }
  };

  onSelectedDialogChange = () => {
    renderMessagesCount = initialRenderMessagesCount;

    if (lastPeer != null) {
      DialogActionCreators.onConversationClosed(lastPeer);
    }

    lastPeer = DialogStore.getSelectedDialogPeer();
    DialogActionCreators.onConversationOpen(lastPeer);
  };

  onMessagesChange = _.debounce(() => {
    this.setState(getStateFromStores());
  }, 10, {maxWait: 50, leading: true});

  loadMessagesByScroll = _.debounce(() => {
    if (lastPeer !== null ) {
      let node = React.findDOMNode(this.refs.MessagesSection);
      let scrollTop = node.scrollTop;
      lastScrolledFromBottom = node.scrollHeight - scrollTop;

      if (node.scrollTop < LoadMessagesScrollTop) {
        DialogActionCreators.onChatEnd(this.state.peer);

        if (this.state.messages.length > this.state.messagesToRender.length) {
          renderMessagesCount += renderMessagesStep;

          if (renderMessagesCount > this.state.messages.length) {
            renderMessagesCount = this.state.messages.length;
          }

          this.setState(getStateFromStores());
        }
      }
    }
  }, 5, {maxWait: 30});
}

export default DialogSection;
