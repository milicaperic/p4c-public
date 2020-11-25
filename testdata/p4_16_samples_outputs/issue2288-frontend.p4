#include <core.p4>
#define V1MODEL_VERSION 20180101
#include <v1model.p4>

header ethernet_t {
    bit<48> dst_addr;
    bit<48> src_addr;
    bit<16> eth_type;
}

header H {
    bit<8> a;
}

struct Headers {
    ethernet_t eth_hdr;
    H          h;
}

struct Meta {
}

parser p(packet_in pkt, out Headers hdr, inout Meta m, inout standard_metadata_t sm) {
    state start {
        pkt.extract<ethernet_t>(hdr.eth_hdr);
        transition accept;
    }
}

control ingress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    @name("ingress.tmp") bit<8> tmp;
    @name("ingress.tmp_0") bit<8> tmp_0;
    apply {
        tmp = h.h.a;
        {
            @name("ingress.z_0") bit<8> z_0 = h.h.a;
            @name("ingress.hasReturned_0") bool hasReturned = false;
            @name("ingress.retval_0") bit<8> retval;
            z_0 = 8w3;
            hasReturned = true;
            retval = 8w1;
            h.h.a = z_0;
            tmp_0 = retval;
        }
        {
            @name("ingress.x_0") bit<8> x_0 = tmp;
            @name("ingress.hasReturned") bool hasReturned_0 = false;
            @name("ingress.retval") bit<8> retval_0;
            hasReturned_0 = true;
            retval_0 = 8w4;
            tmp = x_0;
        }
        h.h.a = tmp;
    }
}

control vrfy(inout Headers h, inout Meta m) {
    apply {
    }
}

control update(inout Headers h, inout Meta m) {
    apply {
    }
}

control egress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    apply {
    }
}

control deparser(packet_out b, in Headers h) {
    apply {
        b.emit<Headers>(h);
    }
}

V1Switch<Headers, Meta>(p(), vrfy(), ingress(), egress(), update(), deparser()) main;

