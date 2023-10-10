--[[
README:

This script can help you accelerate your moves.


This version of the script does NOT support inline tags. In other words,
there shouldn't be two or more tags of the same type in the line.


This is the first version of the script, and there may be many problems and room for development.
If you encounter any bugs while using this script, please feel free to contact me at fr.3pehr@gmail.com
or on Telegram at @mrSprix.

Special thanks to PhoenixTetra who made it possible to accelerate moves with his wonderful idea.

]]

script_name="Accelerated Movement"
script_description="Helps you to accelerate your moves."
script_author="Sprix"
script_version="1.1"

include("karaskel.lua")

function giveaccg(sub, sel)
  dialog_config=
  {
    {x=0,y=0,width=1,height=1,class="label",label="Acceleration:"},
    {class="floatedit",name="acceleration",x=1,y=0,width=1,height=1,value=1}
  }
  buttons={"OK","Cancel"}
  pressed,res=aegisub.dialog.display(dialog_config,buttons,{ok='OK',cancel='Cancel'})
  if pressed=="Cancel" then
    aegisub.cancel()
  end
  if pressed=="OK" then
    giveacc(sub, sel)
  end
end

function giveacc(sub, sel)
  local meta,styles=karaskel.collect_head(sub,false)
  for si, li in ipairs(sel) do
    local line = sub[li]
    karaskel.preproc_line(sub,meta,styles,line)
    text1 = line.text
    local posx1 = text1:match("\\move%(([%d%.%-]+),[%d%.%-]+,[%d%.%-]+,[%d%.%-]+")
    local posy1 = text1:match("\\move%([%d%.%-]+,([%d%.%-]+),[%d%.%-]+,[%d%.%-]+")
    local posx2 = text1:match("\\move%([%d%.%-]+,[%d%.%-]+,([%d%.%-]+),[%d%.%-]+")
    local posy2 = text1:match("\\move%([%d%.%-]+,[%d%.%-]+,[%d%.%-]+,([%d%.%-]+)")
    posx1 = tonumber(posx1)
    posx2 = tonumber(posx2)
    posy1 = tonumber(posy1)
    posy2 = tonumber(posy2)
    local mtime = ""
    if text1:match("\\move%([%d%.%-]+,[%d%.%-]+,[%d%.%-]+,[%d%.%-]+,") then
      mtime = text1:match("\\move%([%d%.%-]+,[%d%.%-]+,[%d%.%-]+,[%d%.%-]+,([^%)]+)%)")..","
    end
    local acc = res["acceleration"]
    local wid = line.height
    local hei = line.width
    local des = line.descent
    if text1:match("\\fs[%d%.%-]") then
      local fs = text1:match("\\fs([%d%.%-]+)")
      fs = tonumber(fs)
      hei = hei * (fs / line.styleref.fontsize)
      des = des * (fs / line.styleref.fontsize)
      wid = wid * (fs / line.styleref.fontsize)
    end
    if text1:match("\\p") then
      des = 0
      local popo = text1:match("m[ bl%d%.%-]+")
      local pp = {}
      local ppp = {}
      for c in popo:gmatch("[%d%.%-]+") do
        table.insert(ppp,c)
      end
      local d = #ppp / 2
      for f = 1,d do
        pp[f] = ppp[2*f]
      end
      for r = 1,#pp do
        pp[r] = tonumber(pp[r])
      end
      local s = pp[1]
      for x = 1,#pp do
        if pp[x] < s then
          s = pp[x]
        end
      end
      local bi = pp[1]
      for y = 1,#pp do
        if pp[y] > bi then
          bi = pp[y]
        end
      end
      wid = bi - s
      local popo2 = text1:match("m[ bl%d%.%-]+")
      local pp2 = {}
      local ppp2 = {}
      for cc in popo2:gmatch("[%d%.%-]+") do
        table.insert(ppp2,cc)
      end
      local dd = #ppp2 / 2
      for ff = 1,dd do
        pp2[ff] = ppp2[2*ff - 1]
      end
      for rr = 1,#pp2 do
        pp2[rr] = tonumber(pp2[rr])
      end
      local s2 = pp2[1]
      for xx = 1,#pp2 do
        if pp2[xx] < s2 then
          s2 = pp2[xx]
        end
      end
      local bi2 = pp2[1]
      for yy = 1,#pp2 do
        if pp2[yy] > bi2 then
          bi2 = pp2[yy]
        end
      end
      hei = bi2 - s2
      wid = wid * (line.styleref.scale_y / 100)
      if text1:match("\\fscy") then
        local fscy = text1:match("\\fscy([%d%.%-]+)")
        fscy = tonumber(fscy)
        wid = wid / (line.styleref.scale_y / 100)
        wid = wid * (fscy / 100)
      end
      hei = hei * (line.styleref.scale_x / 100)
      if text1:match("\\fscx") then
        local fscx = text1:match("\\fscx([%d%.%-]+)")
        fscx = tonumber(fscx)
        hei = hei / (line.styleref.scale_x / 100)
        hei = hei * (fscx / 100)
      end
    else
      if text1:match("\\fscy") then
        local fscyt = text1:match("\\fscy([%d%.%-]+)")
        fscyt = tonumber(fscyt)
        wid = wid / (line.styleref.scale_y / 100)
        wid = wid * (fscyt / 100)
        des = des / (line.styleref.scale_y / 100)
        des = des * (fscyt / 100)
      end
      if text1:match("\\fscx") then
        local fscxt = text1:match("\\fscx([%d%.%-]+)")
        fscxt = tonumber(fscxt)
        hei = hei / (line.styleref.scale_x / 100)
        hei = hei * (fscxt / 100)
      end
    end
    local h = wid
    local w = hei
    local h2 = h / 2
    local w2 = w / 2
    text1=text1:gsub("\\move%([^%(%)]+%)","")
    mssty = {"outline","shadow","scale_x","scale_y","color1","align"}
    mstagsty = {}
    for a = 1,#mssty do
      mstagsty[a] = line.styleref[mssty[a]]
    end
    mstagsty[5]=mstagsty[5]:match("&H%x%x").."&"
    local align = mstagsty[6]
    if text1:match("\\an") then
      align = text1:match("\\an(%d)")
      align = tonumber(align)
      text1=text1:gsub("\\an%d","")
    end
    if posx1 <= posx2 and posy1 < posy2 then
      local npx = posx1
      local npy = posy1
      if align == 1 then
        npy = npy - h
      end
      if align == 2 then
        npy = npy - h
        npx = npx - w2
      end
      if align == 3 then
        npy = npy - h
        npx = npx - w
      end
      if align == 4 then
        npy = npy - h2
      end
      if align == 5 then
        npy = npy - h2
        npx = npx - w2
      end
      if align == 6 then
        npy = npy - h2
        npx = npx - w
      end
      if align == 8 then
        npx = npx - w2
      end
      if align == 9 then
        npx = npx - w
      end
      wid = wid - des
      nposx = npx - wid
      local fsposx = posx2 - posx1
      fsposx = fsposx / wid
      fsposx = fsposx + 1
      fsposx = fsposx * 100
      local fsposy = posy2 - posy1
      fsposy = fsposy / wid
      fsposy = fsposy + 1
      fsposy = fsposy * 100
      text1 = "{\\p1\\an7\\pos("..nposx..","..npy..")\\bord0\\shad0\\fscx100\\fscy100\\1a&HFF&\\t("..mtime..acc..",\\fscx"..fsposx.."\\fscy"..fsposy..")}m 0 0 l "..wid.." 0 "..wid.." "..wid.." 0 "..wid.."{\\p0\\bord"..mstagsty[1].."\\shad"..mstagsty[2].."\\fscx"..mstagsty[3].."\\fscy"..mstagsty[4].."\\1a"..mstagsty[5].."}"..text1
    end
    if posx1 > posx2 and posy1 <= posy2 then
      local npx = posx1
      local npy = posy1
      if align == 1 then
        npy = npy - h
        npx = npx + w
      end
      if align == 2 then
        npy = npy - h
        npx = npx + w2
      end
      if align == 3 then
        npy = npy - h
      end
      if align == 4 then
        npy = npy - h2
        npx = npx + w
      end
      if align == 5 then
        npy = npy - h2
        npx = npx + w2
      end
      if align == 6 then
        npy = npy - h2
      end
      if align == 7 then
        npx = npx + w
      end
      if align == 8 then
        npx = npx + w2
      end
      wid = wid - des
      nposx = npx + wid
      local fsposx = posx1 - posx2
      fsposx = fsposx / wid
      fsposx = fsposx + 1
      fsposx = fsposx * 100
      local fsposy = posy2 - posy1
      fsposy = fsposy / wid
      fsposy = fsposy + 1
      fsposy = fsposy * 100
      text1 = "{\\an9}"..text1.."{\\p1\\pbo0\\pos("..nposx..","..npy..")\\bord0\\shad0\\fscx100\\fscy100\\1a&HFF&\\t("..mtime..acc..",\\fscx"..fsposx.."\\fscy"..fsposy..")}m 0 0 l "..wid.." 0 "..wid.." "..wid.." 0 "..wid
    end
    if posx1 < posx2 and posy2 <= posy1 then
      local npx = posx1
      local npy = posy1
      if align == 2 then
        npx = npx - w2
      end
      if align == 3 then
        npx = npx - w
      end
      if align == 4 then
        npy = npy + h2
      end
      if align == 5 then
        npy = npy + h2
        npx = npx - w2
      end
      if align == 6 then
        npy = npy + h2
        npx = npx - w
      end
      if align == 7 then
        npy = npy + h
      end
      if align == 8 then
        npy = npy + h
        npx = npx - w2
      end
      if align == 9 then
        npy = npy + h
        npx = npx - w
      end
      nposx = npx - wid
      nposy = npy + wid - des
      local fsposx = posx2 - posx1
      fsposx = fsposx / wid
      fsposx = fsposx + 1
      fsposx = fsposx * 100
      local fsposy = posy1 - posy2
      fsposy = fsposy / wid
      fsposy = fsposy + 1
      fsposy = fsposy * 100
      text1 = "{\\p1\\pbo"..wid.."\\an1\\pos("..nposx..","..nposy..")\\bord0\\shad0\\fscx100\\fscy100\\1a&HFF&\\t("..mtime..acc..",\\fscx"..fsposx.."\\fscy"..fsposy..")}m 0 0 l "..wid.." 0 "..wid.." "..wid.." 0 "..wid.."{\\p0\\pbo0\\bord"..mstagsty[1].."\\shad"..mstagsty[2].."\\fscx"..mstagsty[3].."\\fscy"..mstagsty[4].."\\1a"..mstagsty[5].."}"..text1
    end
    if posx2 <= posx1 and posy1 > posy2 then
      local npx = posx1
      local npy = posy1
      if align == 1 then
        npx = npx + w
      end
      if align == 2 then
        npx = npx + w2
      end
      if align == 4 then
        npy = npy + h2
        npx = npx + w
      end
      if align == 5 then
        npy = npy + h2
        npx = npx + w2
      end
      if align == 6 then
        npy = npy + h2
      end
      if align == 7 then
        npy = npy + h
        npx = npx + w
      end
      if align == 8 then
        npy = npy + h
        npx = npx + w2
      end
      if align == 9 then
        npy = npy + h
      end
      nposx = npx + wid
      nposy = npy + wid - des
      local fsposx = posx1 - posx2
      fsposx = fsposx / wid
      fsposx = fsposx + 1
      fsposx = fsposx * 100
      local fsposy = posy1 - posy2
      fsposy = fsposy / wid
      fsposy = fsposy + 1
      fsposy = fsposy * 100
      text1 = "{\\an3}"..text1.."{\\p1\\pbo"..wid.."\\pos("..nposx..","..nposy..")\\bord0\\shad0\\fscx100\\fscy100\\1a&HFF&\\t("..mtime..acc..",\\fscx"..fsposx.."\\fscy"..fsposy..")}m 0 0 l "..wid.." 0 "..wid.." "..wid.." 0 "..wid
    end
    text1=text1:gsub("{}","")
    :gsub("}{","")
    line.text=text1
    sub[li]=line
  end
  aegisub.set_undo_point(script_name)
  return sel
end

aegisub.register_macro(script_name,script_description,giveaccg)
