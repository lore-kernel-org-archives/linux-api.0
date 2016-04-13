From: Pavel Emelyanov <xemul@virtuozzo.com>
Subject: Re: [PATCH 0/2] vfs: Define new syscall getumask.
Date: Wed, 13 Apr 2016 15:05:09 +0300
Message-ID: <570E35F5.90002@virtuozzo.com>
References: <1460547786-16766-1-git-send-email-rjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460547786-16766-1-git-send-email-rjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org, luto@kernel.org, viro@zeniv.linux.org.uk, mathieu.desnoyers@efficios.com, zab@redhat.com, emunson@akamai.com, paulmck@linux.vnet.ibm.com, aarcange@redhat.com, josh@joshtriplett.org, xemul@parallels.com, sfr@canb.auug.org.au, milosz@adfin.com, rostedt@goodmis.org, arnd@arndb.de, ebiederm@xmission.com, gorcunov@openvz.org, iulia.manda21@gmail.com, dave.hansen@linux.intel.com, mguzik@redhat.com, adobriyan@gmail.com, dave@stgolabs.net, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 04/13/2016 02:43 PM, Richard W.M. Jones wrote:
> It's not possible to read the process umask without also modifying it,
> which is what umask(2) does.  A library cannot read umask safely,
> especially if the main program might be multithreaded.
> 
> This patch series adds a trivial system call "getumask" which returns
> the umask of the current process.

Ah! Thanks for this :)

Acked-by: Pavel Emelyanov <xemul@virtuozzo.com>
