From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] seccomp: Add pkru into seccomp_data
Date: Thu, 25 Oct 2018 16:00:10 -0700
Message-ID: <CALCETrX_E5_p1-MjCcdtRQbziCCzXcOCfxRBckZx_zbO1QX=Dw@mail.gmail.com>
References: <20181024153523.10974-1-msammler@mpi-sws.org>
 <87zhv3nrr0.fsf@oldenburg.str.redhat.com>
 <11a706bd-060f-41de-118b-bababfd83b3d@mpi-sws.org>
 <875zxqo0ee.fsf@oldenburg.str.redhat.com>
 <c4d3f5c1-a2dc-5b44-4d12-1fae829a372c@mpi-sws.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <c4d3f5c1-a2dc-5b44-4d12-1fae829a372c@mpi-sws.org>
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
To: Michael Sammler <msammler@mpi-sws.org>
Cc: Florian Weimer <fweimer@redhat.com>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, linuxram@us.ibm.com, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 25, 2018 at 9:42 AM Michael Sammler <msammler@mpi-sws.org> wrote:
>
> On 10/25/2018 11:12 AM, Florian Weimer wrote:
> >> I understand your concern about exposing the number of protection keys
> >> in the ABI. One idea would be to state, that the pkru field (which
> >> should probably be renamed) contains an architecture specific value,
> >> which could then be the PKRU on x86 and AMR (or another register) on
> >> POWER. This new field should probably be extended to __u64 and the
> >> reserved field removed.
> > POWER also has proper read/write bit separation, not PKEY_DISABLE_ACCESS
> > (disable read and write) and PKEY_DISABLE_WRITE like Intel.  It's
> > currently translated by the kernel, but I really need a
> > PKEY_DISABLE_READ bit in glibc to implement pkey_get in case the memory
> > is write-only.
> The idea here would be to simply provide the raw value of the register
> (PKRU on x86, AMR on POWER) to the BPF program and let the BPF program
> (or maybe a higher level library like libseccomp) deal with the
> complications of interpreting this architecture specific value (similar
> how the BPF program currently already has to deal with architecture
> specific system call numbers). If an architecture were to support more
> protection keys than fit into the field, the architecture specific value
> stored in the field might simply be the first protection keys. If there
> was interest, it would be possible to add more architecture specific
> fields to seccomp_data.
> >> Another idea would be to not add a field in the seccomp_data
> >> structure, but instead provide a new BPF instruction, which reads the
> >> value of a specified protection key.
> > I would prefer that if it's possible.  We should make sure that the bits
> > are the same as those returned from pkey_get.  I have an implementation
> > on POWER, but have yet to figure out the implications for 32-bit because
> > I do not know the AMR register size there.
> >
> > Thanks,
> > Florian
> I have had a look at how BPF is implemented and it does not seem to be
> easy to just add an BPF instruction for seccomp since (as far as I
> understand) the code of the classical BPF (as used by seccomp) is shared
> with the code of eBPF, which is used in many parts of the kernel and
> there is at least one interpreter and one JIT compiler for BPF. But
> maybe someone with more experience than me can comment on how hard it
> would be to add an instruction to BPF.
>

You could bite the bullet and add seccomp eBPF support :)
