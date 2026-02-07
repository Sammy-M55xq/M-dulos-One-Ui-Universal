cfgpath="${MODPATH}/common/cfg.sh"
powkey='KEY_POWER'
volupkey='KEY_VOLUMEUP'
voldownkey='KEY_VOLUMEDOWN'
keylist="${powkey} ${volupkey} ${voldownkey}"

detect_keys() {
  local event
  while true; do
    event="$(getevent -lqn -c1)"
    # `KEY.*DOWN` means that the key was pressed, not released
    if echo "${event}" | grep -q "${volupkey}.*DOWN"; then
      echo 'volup' && break
    elif echo "${event}" | grep -q "${voldownkey}.*DOWN"; then
      echo 'voldown' && break
    fi
  done
}

mkcfg() {
  local count
  local key
  count="${1}"
  key="${2}"

  echo "key${count}=${key}" >> "${cfgpath}"
  ui_print ">> ${key} is selected!"
  ui_print
}

upd_complete_var() {
  echo "Complete the installation with ${1} keys selected"
}

interactive() {
  local pressed_key
  local complete
  local choice
  local count

  ui_print '**** Customizing ****'
  ui_print
  ui_print '- Use VOL+ to confirm your choice'
  ui_print '  and VOL- to select next option!'
  ui_print
  sleep 1

  count=0
  complete="$(upd_complete_var ${count})"
  
  while true; do
    for choice in ${keylist} "${complete}"; do
      ui_print "> ${choice}"
      pressed_key="$(detect_keys)"
      case "${pressed_key}" in
        volup) break;;
        voldown) continue;;  # Continue the loop if VOL- has been pressed
      esac
    done

    if [[ "${pressed_key}" == 'volup' ]]; then
      if [[ "${choice%_*}" == 'KEY' ]]; then
        # Add a new key to the conf
        count="$((count + 1))" 
        mkcfg "${count}" "${choice}"
        [[ "${count}" == 2 ]] && break  # Do not add more than 2 keys
        complete="$(upd_complete_var ${count})"
      else
        break  # Complete the installation manually
      fi
    fi
  done
}

fallback() {
  ui_print '- It looks like your device does'
  ui_print '  not have volume buttons'
  ui_print '- Use the power key to trigger the module!'
  mkcfg 1 "${powkey}"
}

main() {
  command -v getevent > /dev/null || abort '! `getevent` command missing'
  if getevent -il | grep -q 'KEY_VOLUME.'; then
    interactive
  else
    fallback
  fi
}

main

LATESTARTSERVICE=true

ui_print "    🔋 ONE-UI-OTIMIZAÇÃO" 
ui_print "    👾 by @Samy_Snap" 
ui_print "    🔌 Melhore a autonomia sem perder desempenho. Indicado para uso diário e jogos."
ui_print " " 
ui_print " " 
sleep 1

ui_print "   🔧 $(getprop ro.product.model) detectado, aplicando otimizações..."
ui_print "   ⚙️ $(getprop ro.hardware) detectado, aplicando Bomba pelo ShellScript..."
sleep 1.5
ui_print "  — Aplicando Script no seu $(getprop ro.build.product)... "
sleep 1.5
ui_print "  — KernelPatch: $(uname -r)"
ui_print " " 
ui_print "  🔧 Aplicando permissões..." 
sleep 1.5

# Extrai os arquivos do módulo
unzip -o "$ZIPFILE" 'oneuiboost/*' -d "$MODPATH" >&2

# Garante que os scripts tenham permissão de execução
chmod 0755 "$MODPATH/oneuiboost/post-fs-data.sh" 2>/dev/null
chmod 0755 "$MODPATH/oneuiboost/service.sh" 2>/dev/null
chmod 0755 "$MODPATH/oneuiboost/deep_props.sh" 2>/dev/null

# Define permissões padrão para todo o conteúdo
set_perm_recursive "$MODPATH/oneuiboost" 0 0 0774 0774

sleep 1.5
ui_print "Módulo instalado com êxito, reinicie seu dispositivo. "