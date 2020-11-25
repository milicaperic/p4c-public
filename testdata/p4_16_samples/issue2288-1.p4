#include <core.p4>
#include <v1model.p4>

header ethernet_t {
    bit<48> dst_addr;
    bit<48> src_addr;
    bit<16> eth_type;
}

header H {
    bit<8> a;
    bit<8> b;
}

struct Headers {
    ethernet_t eth_hdr;
    H h;
}

struct Meta {
}


parser p(packet_in pkt, out Headers hdr, inout Meta m, inout standard_metadata_t sm) {
    state start {
        transition parse_hdrs;
    }
    state parse_hdrs {
        pkt.extract(hdr.eth_hdr);
        transition accept;
    }
}

bit<8> f(in bit<8> x, in bit<8> y, out bit<8> z) {
    z = x | y;
    return 8w4;
}

bit<8> g(out bit<8> w) {
    w = 8w3;
    return 8w1;
}
control ingress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {

    apply {
        f(h.h.a, g(h.h.a), h.h.b);
    }
}

control vrfy(inout Headers h, inout Meta m) { apply {} }

control update(inout Headers h, inout Meta m) { apply {} }

control egress(inout Headers h, inout Meta m, inout standard_metadata_t sm) { apply {} }

control deparser(packet_out b, in Headers h) { apply {b.emit(h);} }

V1Switch(p(), vrfy(), ingress(), egress(), update(), deparser()) main;

