/*
 * Copyright (C) 2015 Actor LLC. <https://actor.im>
 */

package im.actor.model.api.rpc;
/*
 *  Generated by the Actor API Scheme generator.  DO NOT EDIT!
 */

import im.actor.model.droidkit.bser.Bser;
import im.actor.model.droidkit.bser.BserParser;
import im.actor.model.droidkit.bser.BserObject;
import im.actor.model.droidkit.bser.BserValues;
import im.actor.model.droidkit.bser.BserWriter;
import im.actor.model.droidkit.bser.DataInput;
import im.actor.model.droidkit.bser.DataOutput;
import static im.actor.model.droidkit.bser.Utils.*;
import java.io.IOException;
import im.actor.model.network.parser.*;
import java.util.List;
import java.util.ArrayList;
import im.actor.model.api.*;

public class ResponseGetParameters extends Response {

    public static final int HEADER = 0x87;
    public static ResponseGetParameters fromBytes(byte[] data) throws IOException {
        return Bser.parse(new ResponseGetParameters(), data);
    }

    private List<Parameter> parameters;

    public ResponseGetParameters(List<Parameter> parameters) {
        this.parameters = parameters;
    }

    public ResponseGetParameters() {

    }

    public List<Parameter> getParameters() {
        return this.parameters;
    }

    @Override
    public void parse(BserValues values) throws IOException {
        List<Parameter> _parameters = new ArrayList<Parameter>();
        for (int i = 0; i < values.getRepeatedCount(1); i ++) {
            _parameters.add(new Parameter());
        }
        this.parameters = values.getRepeatedObj(1, _parameters);
    }

    @Override
    public void serialize(BserWriter writer) throws IOException {
        writer.writeRepeatedObj(1, this.parameters);
    }

    @Override
    public String toString() {
        String res = "tuple GetParameters{";
        res += "}";
        return res;
    }

    @Override
    public int getHeaderKey() {
        return HEADER;
    }
}
