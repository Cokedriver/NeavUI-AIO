local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database
local LSM = LibStub("LibSharedMedia-3.0")

-- Load All SharedMedia

C['nMedia'].font = LSM:Fetch("font", C['nMedia'].font)

C['nCore'].selfbuffs.sound = LSM:Fetch("sound", C['nCore'].selfbuffs.sound)