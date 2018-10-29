From: Jann Horn <jannh@google.com>
Subject: Re: [RFC PATCH] seccomp: Add protection keys into seccomp_data
Date: Mon, 29 Oct 2018 17:42:13 +0100
Message-ID: <CAG48ez3ek9E=LU9ASMMfOYgDFqfY-FREpMDjT=Vw8PuX3-BJOA@mail.gmail.com>
References: <20181029112343.27454-1-msammler@mpi-sws.org>
 <CAGXu5jJ2fFmEXfUzga3XBXcsHPuPWWf5zLeyn8+Z1oZVa8oTuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <CAGXu5jJ2fFmEXfUzga3XBXcsHPuPWWf5zLeyn8+Z1oZVa8oTuQ@mail.gmail.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Kees Cook <keescook@chromium.org>
Cc: wad@chromium.org, Linux API <linux-api@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, linuxram@us.ibm.com, Andy Lutomirski <luto@amacapital.net>, msammler@mpi-sws.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

On Mon, Oct 29, 2018 at 5:25 PM Kees Cook <keescook@chromium.org> wrote:
> On Mon, Oct 29, 2018 at 4:23 AM, Michael Sammler <msammler@mpi-sws.org> wrote:
> > Add the current value of an architecture specific protection keys
> > register (currently PKRU on x86) to data available for seccomp-bpf
> > programs to work on. This allows filters based on the currently
> > enabled protection keys.
> >
> > Support for protection keys on the POWER architecture is not part of
> > this patch since I do not have access to a PowerPC, but adding support
> > for it can be achieved by setting sd->pkeys to the AMR register in
> > populate_seccomp_data.
> >
> > One use case for this patch is disabling unnecessary system calls for a
> > library (e.g. network i/o for a crypto library) while the library runs
> > without disabling the system calls for the whole program (by changing
> > the protection keys before and after the library executes). Using this
> > one could ensure that the library behaves a expected (e.g. the crypto
> > library not sending private keys to a malicious server).
> >
> > This patch also enables lightweight sandboxing of untrusted code using
> > memory protection keys: Protection keys provide memory isolation but
> > for a sandbox system call isolation is needed as well. This patch
> > allows writing a seccomp filter to prevent system calls by the
> > untrusted code while still allowing system calls for the trusted code.
>
> Isn't PKU instruction based? Couldn't a malicious library just change
> the state of the MPK registers? This seems like an easy way to bypass
> any filters that used PKU. I'm not convinced this is a meaningful
> barrier that should be enforced by seccomp.

The idea is that if you know that there are no unwanted WRPKRU
instructions in your code, and all WRPKRU instructions in your code
are directly followed by code that verifies correctness of the
protection key, then you can implement lightweight sandboxes inside a
single process. See https://arxiv.org/pdf/1801.06822.pdf for one
description of this approach.

> This can also be done with a signal handler with SECCOMP_RET_TRAP and
> check instruction pointer vs PKU state.

But then you can't prevent an attacker from just jumping directly to
your syscall instruction. And it's slow.
