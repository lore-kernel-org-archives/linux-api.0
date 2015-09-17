From: Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/2] selftests/pstore: add pstore test scripts going with
 reboot
Date: Thu, 17 Sep 2015 14:54:45 +0900
Message-ID: <55FA55A5.5020605@hitachi.com>
References: <20150908110615.9783.69477.stgit@arietta>	<20150908110620.9783.33823.stgit@arietta> <CAGXu5j+Ha0t-acFc+morgUiDRCHGdx8QHySX29PYpnj4QFiJhA@mail.gmail.com> <55F78563.50006@hitachi.com> <753241EEF6DFAB4CAF20F32F515C4E358B347A@GSjpTK1DCembx02.service.hitachi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <753241EEF6DFAB4CAF20F32F515C4E358B347A-RKwZE6o2dOX6mtb5pcma++hNMziWB107FCd8Q96Dh0LR7s880joybQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?6Zi/5Y+j6Kqg5Y+4IC8gQUdVQ0hJ77yMU0VJSkk=?= <seiji.aguchi.tr-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mark Salyzyn <salyzyn-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

 >> +prlog "Causing kernel crash ..."
 >> +
 >> +# enable all functions triggered by sysrq
 >> +echo 1 > /proc/sys/kernel/sysrq
 >> +# setting to reboot in 3 seconds after panic
 >> +echo 3 > /proc/sys/kernel/panic
 >> +# setting to cause panic when oops occurs
 >> +echo 1 > /proc/sys/kernel/panic_on_oops
 >> +
 >> +# create a file as reboot flag
 >> +touch $REBOOT_FILE
 >> +sync
 >> +
 >> +# cause crash
 >> +echo c > /proc/sysrq-trigger
 >
 > Do you need to stop kdump service before the sysrq?

Yes, I should check /sys/kernel/kexec_crash_loaded. If the value is
1, this script should try to unload kexec kernel.

 > Or, does it cover oops and kdump case?

No, not yet. I think we should support oops case at first.

Best regards,
Hiraku Toyooka

=E9=98=BF=E5=8F=A3=E8=AA=A0=E5=8F=B8 / AGUCHI=EF=BC=8CSEIJI wrote:
>
>> +prlog "Causing kernel crash ..."
>> +
>> +# enable all functions triggered by sysrq
>> +echo 1 > /proc/sys/kernel/sysrq
>> +# setting to reboot in 3 seconds after panic
>> +echo 3 > /proc/sys/kernel/panic
>> +# setting to cause panic when oops occurs
>> +echo 1 > /proc/sys/kernel/panic_on_oops
>> +
>> +# create a file as reboot flag
>> +touch $REBOOT_FILE
>> +sync
>> +
>> +# cause crash
>> +echo c > /proc/sysrq-trigger
>
> Do you need to stop kdump service before the sysrq?
> Or, does it cover oops and kdump case?
>
> Seiji
>
>> -----Original Message-----
>> From: =E8=B1=8A=E5=B2=A1=E6=8B=93 / Toyooka=EF=BC=8CHiraku
>> Sent: Tuesday, September 15, 2015 11:42 AM
>> To: Kees Cook
>> Cc: LKML; Tony Luck; Linux API; Anton Vorontsov; Shuah Khan; Mark Sa=
lyzyn; Colin Cross; =E9=98=BF=E5=8F=A3=E8=AA=A0=E5=8F=B8 / AGUCHI=EF=BC=
=8CSEIJI
>> Subject: Re: [PATCH 2/2] selftests/pstore: add pstore test scripts g=
oing with reboot
>>
>> Hello Kees,
>>
>>   >> +run_crash:
>>   >> +       @sh pstore_crash_test || echo "pstore_crash_test: [FAIL=
]"
>>   >
>>   > This is probably better written to exit 1 on failure, otherwise =
it
>>   > just _says_ it fails. (Though lots of selftests in the tree alre=
ady
>>   > have this problem, it's best to avoid the pattern for new stuff.=
)
>>   > Maybe something like:
>>   >
>>   >      @sh pstore_crash_test || { echo "pstore_crash_test: [FAIL]"=
;
>> exit 1; }
>>
>> OK. I'll add the "exit 1".
>>
>>   >> +prlog -n "Checking dmesg files exist in pstore filesystem ... =
"
>>   >> +if [ -e dmesg-${backend}-0 ]; then
>>   >> +    prlog "ok"
>>   >> +    for f in `ls dmesg-${backend}-*`; do
>>   >> +       prlog -e "\t${f}"
>>   >> +    done
>>   >> +else
>>   >> +    prlog "FAIL"
>>   >> +    rc=3D1
>>   >> +fi
>>   >
>>   > This test pattern is repeated a lot. Maybe better to create a he=
lper
>>   > function instead? It could make the tests much more readable.
>>
>> Yes, I should make a helper function in v2.
>>
>> Best regards,
>> Hiraku Toyooka

--=20
Hiraku Toyooka
Systems Productivity Research Dept. / Linux Technology Center
Center for Technology Innovation - Systems Engineering, Hitachi Ltd.
