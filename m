From: =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Subject: Re: [PATCH v4] signal: add taskfd_send_signal() syscall
Date: Thu, 06 Dec 2018 13:45:39 +0100
Message-ID: <b0e946bcac12358841c9a99017da819b00794d9c.camel@bitron.ch>
References: <20181206121858.12215-1-christian@brauner.io>
         <87h8fq7s84.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87h8fq7s84.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>, Christian Brauner <christian@brauner.io>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, serge@hallyn.com, jannh@google.com, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, keescook@chromium.org, tglx@linutronix.de, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 2018-12-06 at 13:30 +0100, Florian Weimer wrote:
> * Christian Brauner:
> 
> > /* zombies */
> > Zombies can be signaled just as any other process. No special error will be
> > reported since a zombie state is an unreliable state (cf. [3]).
> 
> I still disagree with this analysis.  If I know that the target process
> is still alive, and it is not, this is a persistent error condition
> which can be reliably reported.  Given that someone might send SIGKILL
> to the process behind my back, detecting this error condition could be
> useful.

As I understand it, kill() behaves the same way. I think it's good that
this new syscall keeps the behavior as close as possible to kill().
E.g., this would allow emulating kill() (or a higher level API
equivalent) on top of taskfds without subtle differences in behavior.

As the new syscall supports flags, we could consider introducing a flag
that changes the behavior in the zombie case. However, I think that
should be a separate discussion (after merge of the syscall) and the
default behavior makes sense as is.

Jürg
