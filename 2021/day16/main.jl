lines = readlines("input.txt")

HEX_TO_BIN = Dict(
    '0' => "0000",
    '1' => "0001",
    '2' => "0010",
    '3' => "0011",
    '4' => "0100",
    '5' => "0101",
    '6' => "0110",
    '7' => "0111",
    '8' => "1000",
    '9' => "1001",
    'A' => "1010",
    'B' => "1011",
    'C' => "1100",
    'D' => "1101",
    'E' => "1110",
    'F' => "1111"
)

PACKET_TYPE_LITERL = 4

struct Packet
    version
    packet_type
    value
    sub_packets
end

function hex_to_bin(hex)
    bin = ""
    for x in hex
        bin *= HEX_TO_BIN[x]
    end

    return bin
end

function decode(transmission, index)
    version = parse(Int, transmission[index:index+2], base=2)
    packet_type = parse(Int, transmission[index+3:index+5], base=2)

    if packet_type == PACKET_TYPE_LITERL 
        value, index = get_literal_value(transmission, index+6)
        return Packet(version, packet_type, value, []), index
    end

    length_type_id = parse(Int, transmission[index+6], base=2)
    if length_type_id == 0
        sub_packets, index = get_subpackets_by_length(transmission, index+7)
    else
        sub_packets, index = get_subpackets_by_number(transmission, index+7)
    end

    return Packet(version, packet_type, nothing, sub_packets), index
end

function get_subpackets_by_length(transmission, index)
    sub_packets = []
    length_of_subpackets = parse(Int, transmission[index:index+14], base=2)

    count = 0
    index += 15
    while count < length_of_subpackets
        sub_packet, new_index = decode(transmission, index)
        push!(sub_packets, sub_packet)
        count += new_index - index

        index = new_index
    end

    return sub_packets, index
end

function get_subpackets_by_number(transmission, index)
    sub_packets = []
    number_of_subpackets = parse(Int, transmission[index:index+10], base=2)

    index += 11
    for i in 1:number_of_subpackets
        sub_packet, index = decode(transmission, index)
        push!(sub_packets, sub_packet)
    end

    return sub_packets, index
end

function get_literal_value(transmission, start)
    values = ""
    index = start
    while true
        values *= transmission[index+1:index+4]
        if transmission[index] == '0' break end
        index += 5
    end

    return parse(Int, values, base=2), index + 5
end

function sum_versions(packet)
    version = packet.version
    for sub_packet in packet.sub_packets
        version += sum_versions(sub_packet)
    end

    return version
end

function solution_part_1(transmission)
    packet, index = decode(transmission, 1)

    return sum_versions(packet)
end

transmission = hex_to_bin(lines[1])
println("Solution part 1: ", solution_part_1(transmission))