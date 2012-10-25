From: Stanislav Kinsbursky <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v8 2/5] ipc: add sysctl to specify desired next object
 id
Date: Thu, 25 Oct 2012 11:53:10 +0400
Message-ID: <5088EFE6.2040900@parallels.com>
References: <20121024151555.5642.79086.stgit@localhost.localdomain> <20121024153509.5642.76385.stgit@localhost.localdomain> <20121024144123.0a77584b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121024144123.0a77584b.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org" <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pavel Emelianov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "catalin.marinas-5wv7dgnIgG8@public.gmane.org" <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "will.deacon-5wv7dgnIgG8@public.gmane.org" <will.deacon-5wv7dgnIgG8@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org" <cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org>, "joe.korty-oXJCJecloQs@public.gmane.org" <joe.korty-oXJCJecloQs@public.gmane.org>, "dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org" <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <devel@openvz.o>
List-Id: linux-api@vger.kernel.org

25.10.2012 01:41, Andrew Morton =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Wed, 24 Oct 2012 19:35:09 +0400
> Stanislav Kinsbursky <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
>
>> This patch adds 3 new variables and sysctls to tune them (by one "ne=
xt_id"
>> variable for messages, semaphores and shared memory respectively).
>> This variable can be used to set desired id for next allocated IPC o=
bject.
>> By default it's equal to -1 and old behaviour is preserved.
>> If this variable is non-negative, then desired idr will be extracted=
 from it
>> and used as a start value to search for free IDR slot.
>>
>> Notes:
>> 1) this patch doesn't garantee, that new object will have desired id=
=2E So it's
>> up to user space how to handle new object with wrong id.
>> 2) After sucessfull id allocation attempt, "next_id" will be set bac=
k to -1
>> (if it was non-negative).
>>
>> --- a/ipc/ipc_sysctl.c
>> +++ b/ipc/ipc_sysctl.c
>> @@ -158,6 +158,7 @@ static int proc_ipcauto_dointvec_minmax(ctl_tabl=
e *table, int write,
>>
>>   static int zero;
>>   static int one =3D 1;
>> +static int int_max =3D INT_MAX;
>>
>>   static struct ctl_table ipc_kern_table[] =3D {
>>   	{
>> @@ -227,6 +228,33 @@ static struct ctl_table ipc_kern_table[] =3D {
>>   		.extra1		=3D &zero,
>>   		.extra2		=3D &one,
>>   	},
>> +	{
>> +		.procname	=3D "sem_next_id",
>> +		.data		=3D &init_ipc_ns.ids[IPC_SEM_IDS].next_id,
>> +		.maxlen		=3D sizeof(init_ipc_ns.ids[IPC_SEM_IDS].next_id),
>> +		.mode		=3D 0644,
>> +		.proc_handler	=3D proc_ipc_dointvec_minmax,
>> +		.extra1		=3D &zero,
>> +		.extra2		=3D &int_max,
>> +	},
>> +	{
>> +		.procname	=3D "msg_next_id",
>> +		.data		=3D &init_ipc_ns.ids[IPC_MSG_IDS].next_id,
>> +		.maxlen		=3D sizeof(init_ipc_ns.ids[IPC_MSG_IDS].next_id),
>> +		.mode		=3D 0644,
>> +		.proc_handler	=3D proc_ipc_dointvec_minmax,
>> +		.extra1		=3D &zero,
>> +		.extra2		=3D &int_max,
>> +	},
>> +	{
>> +		.procname	=3D "shm_next_id",
>> +		.data		=3D &init_ipc_ns.ids[IPC_SHM_IDS].next_id,
>> +		.maxlen		=3D sizeof(init_ipc_ns.ids[IPC_SHM_IDS].next_id),
>> +		.mode		=3D 0644,
>> +		.proc_handler	=3D proc_ipc_dointvec_minmax,
>> +		.extra1		=3D &zero,
>> +		.extra2		=3D &int_max,
>> +	},
>>   	{}
>>   };
>
> ipc_kern_table[] is (badly) documented in
> Documentation/sysctl/kernel.txt.  Can we at least mention these
> controls in there?  Better, create a new way of properly documenting
> each control and document these three in that manner?  Better still,
> document all the other ones as well ;)
>

Yes, sure. I'll do my best.

> The patch adds these controls to CONFIG_CHECKPOINT_RESTORE=3Dn kernel=
s.
> Why is this?
>

I'll fix this.

--=20
Best regards,
Stanislav Kinsbursky
