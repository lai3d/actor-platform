package im.actor.core.api;
/*
 *  Generated by the Actor API Scheme generator.  DO NOT EDIT!
 */

import im.actor.runtime.bser.*;

import java.io.IOException;

public class MessageUnsupported extends Message {

    private int key;
    private byte[] content;

    public MessageUnsupported(int key, byte[] content) {
        this.key = key;
        this.content = content;
    }

    @Override
    public int getHeader() {
        return this.key;
    }

    @Override
    public void parse(BserValues values) throws IOException {
        throw new IOException("Parsing is unsupported");
    }

    @Override
    public void serialize(BserWriter writer) throws IOException {
        writer.writeRaw(content);
    }

}
