From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] seccomp: Add pkru into seccomp_data
Date: Thu, 25 Oct 2018 11:12:25 +0200
Message-ID: <875zxqo0ee.fsf@oldenburg.str.redhat.com>
References: <20181024153523.10974-1-msammler@mpi-sws.org>
 <87zhv3nrr0.fsf@oldenburg.str.redhat.com>
 <11a706bd-060f-41de-118b-bababfd83b3d@mpi-sws.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <11a706bd-060f-41de-118b-bababfd83b3d@mpi-sws.org> (Michael
 Sammler's message of "Thu, 25 Oct 2018 10:39:17 +0200")
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
Cc: Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org, Ram Pai <linuxram@us.ibm.com>, Andy Lutomirski <luto@amacapital.net>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

* Michael Sammler:

> Thank you for the pointer about the POWER implementation. I am not
> familiar with POWER in general and its protection key feature at
> all. Would the AMR register be the correct register to expose here?

Yes, according to my notes, the register is called AMR (special purpose
register 13).

> I understand your concern about exposing the number of protection keys
> in the ABI. One idea would be to state, that the pkru field (which
> should probably be renamed) contains an architecture specific value,
> which could then be the PKRU on x86 and AMR (or another register) on
> POWER. This new field should probably be extended to __u64 and the
> reserved field removed.

POWER also has proper read/write bit separation, not PKEY_DISABLE_ACCESS
(disable read and write) and PKEY_DISABLE_WRITE like Intel.  It's
currently translated by the kernel, but I really need a
PKEY_DISABLE_READ bit in glibc to implement pkey_get in case the memory
is write-only.

> Another idea would be to not add a field in the seccomp_data
> structure, but instead provide a new BPF instruction, which reads the
> value of a specified protection key.

I would prefer that if it's possible.  We should make sure that the bits
are the same as those returned from pkey_get.  I have an implementation
on POWER, but have yet to figure out the implications for 32-bit because
I do not know the AMR register size there.

Thanks,
Florian
