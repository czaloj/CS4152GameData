local Turret = {}


-- generates a turret in the level at the specified x, y, and z coordinates
-- the ex, ey, and ez params are the world space euler angles for orientation
function Turret.generate(x, y, z, ex, ey, ez)
  eIDTurret = ECS.Templates.Turret()

  cIDPos = ECS.getComponentID("Position", eIDTurret)
  ECS.Position.setPosition(cIDPos, x, y, z)
  ECS.Position.setOrientation(cIDPos, ex, ey, ez)

  cIDPhysTurret = ECS.getComponentID("BulletObject", eIDTurret)
  ECS.BulletObject.createBody(cIDPhysTurret)
  
  return eIDTurret
end

-- shoots a projectile from the turret with the specified eID
function Turret.shoot(eIDTurret, force)
  -- Get player info
  cID = ECS.getComponentID("Position", eIDTurret)
  if cID ~= 0 then
    x,y,z = ECS.Position.getPosition(cID)
    fx,fy,fz = ECS.Position.getForward(cID)
    ux,uy,uz = ECS.Position.getUp(cID)
  
    -- Spawn ball
    eID = ECS.Templates.Projectile()
    cIDPos = ECS.getComponentID("Position", eID)
    ECS.Position.setPosition(cIDPos, x + (1.25 * fx) + (.35 * ux), y + (1.25  * fy) + (.35 * uy), z + (1.25  * fz) + (.35 * uz)) 

   -- Shoot ball
    cIDPhys = ECS.getComponentID("BulletObject", eID)
    ECS.BulletObject.createBody(cIDPhys)
    ECS.BulletObject.applyForce(cIDPhys, fx * force, fy * force, fz * force)
  end
end

function Turret.updateTurrets(turretTable, dt)
  for index, turret in pairs(turretTable) do
    turret["timer"] = turret["timer"] + dt
    if turret["timer"] > turret["shootRate"] then
      Turret.shoot(turret["eid"], turret["force"])
      turret["timer"] = 0
    end
  end
end

return Turret