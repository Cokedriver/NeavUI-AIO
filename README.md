# Neav UI

This is a Github mirror of Neav UI on WoWInterface.
With a All In One style vs several seperate addons.

## Addons included

- !Beautycase
- !Colorz
- OmniCC
- nBuff
- nChat
- nCore
- nMainbar
- nMinimap
- nPlates
- nPower
- nTooltip
- oUF
- oUF_Neav
- oUF_NeavRaid

## Known issues

Known issues

- !Colorz cause an ui-block-error (not lua error!), because we change
  the value of the global table, ignore this or delete
  `PowerBarColor['MANA'] = {r = 0/255, g = 0.55, b = 1}` in the
  `!Colorz.lua` file.

  