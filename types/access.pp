# @summary A deny or permit line for Asterisk configuration
#
# A couple of configuration files let administrators configure accesses. They
# are usually order-dependent so one can interleave permit and deny lines to
# create complex permissions.
type Asterisk::Access = Hash[Enum['permit','deny'], String[1], 1, 1]
