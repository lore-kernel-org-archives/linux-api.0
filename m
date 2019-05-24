From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v3 1/2] pid: add pidfd_open()
Date: Fri, 24 May 2019 12:54:00 +0200
Message-ID: <20190524105358.dfnelxhxodkvwbcn@brauner.io>
References: <20190520155630.21684-1-christian@brauner.io>
 <20190521143220.crb2zyvdov3fl4g7@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190521143220.crb2zyvdov3fl4g7@brauner.io>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: jannh@google.com, oleg@redhat.com, viro@zeniv.linux.org.uk, torvalds@linux-foundation.org, arnd@arndb.de
Cc: linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, linux-mips@vger.kernel.org, dhowells@redhat.com, joel@joelfernandes.org, linux-kselftest@vger.kernel.org, sparclinux@vger.kernel.org, elena.reshetova@intel.com, linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, dancol@google.com, kernel-team@android.com, serge@hallyn.com, linux-xtensa@linux-xtensa.org, keescook@chromium.org, linux-m68k@lists.linux-m68k.org, luto@kernel.org, tglx@linutronix.de, surenb@google.com, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-api@vger.kernel.org, cyphar@cyphar.com, luto@amacapital.net, ebiederm@xmission.com, linux-alpha@vger.kernel.org, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

On Tue, May 21, 2019 at 04:32:20PM +0200, Christian Brauner wrote:
> On Mon, May 20, 2019 at 05:56:29PM +0200, Christian Brauner wrote:
> > This adds the pidfd_open() syscall. It allows a caller to retrieve pollable
> > pidfds for a process which did not get created via CLONE_PIDFD, i.e. for a
> > process that is created via traditional fork()/clone() calls that is only
> > referenced by a PID:
> > 
> > int pidfd = pidfd_open(1234, 0);
> > ret = pidfd_send_signal(pidfd, SIGSTOP, NULL, 0);
> > 
> > With the introduction of pidfds through CLONE_PIDFD it is possible to
> > created pidfds at process creation time.
> > However, a lot of processes get created with traditional PID-based calls
> > such as fork() or clone() (without CLONE_PIDFD). For these processes a
> > caller can currently not create a pollable pidfd. This is a problem for
> > Android's low memory killer (LMK) and service managers such as systemd.
> > Both are examples of tools that want to make use of pidfds to get reliable
> > notification of process exit for non-parents (pidfd polling) and race-free
> > signal sending (pidfd_send_signal()). They intend to switch to this API for
> > process supervision/management as soon as possible. Having no way to get
> > pollable pidfds from PID-only processes is one of the biggest blockers for
> > them in adopting this api. With pidfd_open() making it possible to retrieve
> > pidfds for PID-based processes we enable them to adopt this api.
> > 
> > In line with Arnd's recent changes to consolidate syscall numbers across
> > architectures, I have added the pidfd_open() syscall to all architectures
> > at the same time.
> > 
> > Signed-off-by: Christian Brauner <christian@brauner.io>
> > Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> 
> This now also carries a Reviewed-by from David.
> 
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Jann Horn <jannh@google.com>
> > Cc: David Howells <dhowells@redhat.com>
> > Cc: Andy Lutomirsky <luto@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Aleksa Sarai <cyphar@cyphar.com>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: linux-api@vger.kernel.org
> 
> I've moved pidfd_open() into my for-next branch together with Joel's
> pidfd polling changes. Everything is based on v5.2-rc1.
> 
> The chosen syscall number for now is 434. David is going to send out
> another pile of mount api related syscalls. I'll coordinate with him
> accordingly prior to the 5.3 merge window.

After talking to Arnd, I split the syscall addition and the per-arch
wiring-up of pidfd_open() into two patches. There are no functional
changes and everything is still sitting in for-next.

Thanks!
Christian
