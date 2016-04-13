From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v4 0/3] vfs: Define new syscall umask2 [formerly getumask]
Date: Wed, 13 Apr 2016 12:37:42 -0700
Message-ID: <570EA006.5010608@zytor.com>
References: <1460574336-18930-1-git-send-email-rjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460574336-18930-1-git-send-email-rjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, akpm@linux-foundation.org, luto@kernel.org, viro@zeniv.linux.org.uk, mathieu.desnoyers@efficios.com, zab@redhat.com, emunson@akamai.com, paulmck@linux.vnet.ibm.com, aarcange@redhat.com, josh@joshtriplett.org, xemul@parallels.com, sfr@canb.auug.org.au, milosz@adfin.com, rostedt@goodmis.org, arnd@arndb.de, ebiederm@xmission.com, gorcunov@openvz.org, iulia.manda21@gmail.com, dave.hansen@linux.intel.com, mguzik@redhat.com, adobriyan@gmail.com, dave@stgolabs.net, linux-api@vger.kernel.org, gorcunov@gmail.com, fw@deneb.enyo.de, walters@verbum.org
List-Id: linux-api@vger.kernel.org

On 04/13/16 12:05, Richard W.M. Jones wrote:
> v3 -> v4:
>
>   - Rename the syscall: getumask becomes umask2.
>
>   - Add flags parameter, with one flag (UMASK_GET_MASK).
>
>   - Expand the rationale for this change in the first commit message.
>
>
> It's not possible to read the process umask without also modifying it,
> which is what umask(2) does.  A library cannot read umask safely,
> especially if the main program might be multithreaded.
>

I wouldn't say "if"; that is the case when it matters.

I have to say I'm skeptic to the need for umask2() as opposed to 
getumask().  I would also like to be able to get the umask of another 
process, which would argue for adding it to /proc anyway.

	-hpa
