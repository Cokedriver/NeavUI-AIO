local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database
local LSM = LibStub("LibSharedMedia-3.0")

-- Load All SharedMedia

C['nMedia'].font = LSM:Fetch("font", C['nMedia'].font)
C['nMedia'].warnsound = LSM:Fetch("sound", C['nMedia'].warnsound)