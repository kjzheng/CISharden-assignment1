#!/bin/bash

PermitRootLoginpassfail="$(egrep -i '^PermitRootLogin\s+no' /etc/ssh/sshd_config)"
PermitEmptyPasswordspassfail="$(egrep -i "^PermitEmptyPasswords\s+no" /etc/ssh/sshd_config)"
EnsureSSHProcotolsetto2passfail="$(egrep -i "^Protocol\s+2" /etc/ssh/sshd_config)"
Ensurepasswordexpireless90days="$(grep  "^PASS_MAX_DAYS" /etc/login.defs | awk '{print $2}')"
Ensuresystemaccountsnonlogin="$(egrep -v "^\+" /etc/passwd | awk -F: '($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $3<1000 && $7!="/usr/sbin/nologin" && $7!="/bin/false") {print}' )"

echo "$(date)" >> ~/zzz/MSS\ assignment\ 1/bash\ script/CISbench.log
echo "CIS Benchmarks check:" >> ~/zzz/MSS\ assignment\ 1/bash\ script/CISbench.log

if [[ -z "$PermitRootLoginpassfail" ]]; then
  echo "SSH root login is enabled, not compliant" >> ~/zzz/MSS\ assignment\ 1/bash\ script/CISbench.log
elif [[ -n "$PermitRootLoginpassfail" ]]; then
  echo "SSH root login is disabled" >> ~/zzz/MSS\ assignment\ 1/bash\ script/CISbench.log
fi

if [[ -z "$PermitEmptyPasswordspassfail" ]]; then
  echo "SSH PermitEmptyPasswords is enabled, not compliant" >> ~/zzz/MSS\ assignment\ 1/bash\ script/CISbench.log
elif [[ -n "$PermitEmptyPasswordspassfail" ]]; then
  echo "SSH PermitEmptyPasswords is disabled" >> ~/zzz/MSS\ assignment\ 1/bash\ script/CISbench.log
fi

if [[ -z "$EnsureSSHProcotolsetto2passfail" ]]; then
  echo "SSH Protocol is not 2, not compliant" >> ~/zzz/MSS\ assignment\ 1/bash\ script/CISbench.log
elif [[ -n "$EnsureSSHProcotolsetto2passfail" ]]; then
  echo "SSH Protocol is 2" >> ~/zzz/MSS\ assignment\ 1/bash\ script/CISbench.log
fi

if [[ "$Ensurepasswordexpireless90days" -gt 90 ]]; then
  echo "Password expiration is not 90 days or less, not compliant" >> ~/zzz/MSS\ assignment\ 1/bash\ script/CISbench.log
else
  echo "Password expiration is 90days and less" >> ~/zzz/MSS\ assignment\ 1/bash\ script/CISbench.log
fi

if [[ -n "$Ensuresystemaccountsnonlogin" ]]; then
  echo "System accounts are not secured to nonlogin, not compliant" >> ~/zzz/MSS\ assignment\ 1/bash\ script/CISbench.log
elif [[ -z "$Ensuresystemaccountsnonlogin" ]]; then
  echo "System accounts are secured to nonlogin" >> ~/zzz/MSS\ assignment\ 1/bash\ script/CISbench.log
fi

if [[ -z "$PermitRootLoginpassfail" ]] || [[ -z "$PermitEmptyPasswordspassfail" ]] || [[ -z "$EnsureSSHProcotolsetto2passfail" ]] || [[ "$Ensurepasswordexpireless90days" -gt 90 ]] || [[ -n "$Ensuresystemaccountsnonlogin" ]]; then
  tail -7 ~/zzz/MSS\ assignment\ 1/bash\ script/CISbench.log | mail -s "CIS benchmarks check" kjz42324@gmail.com
else
  false
fi
