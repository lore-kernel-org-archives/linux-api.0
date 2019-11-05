From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 1/1] userfaultfd: require CAP_SYS_PTRACE for
 UFFD_FEATURE_EVENT_FORK
Date: Tue, 5 Nov 2019 11:33:16 -0500
Message-ID: <20191105163316.GI30717@redhat.com>
References: <1572967777-8812-1-git-send-email-rppt@linux.ibm.com>
 <1572967777-8812-2-git-send-email-rppt@linux.ibm.com>
 <CAKOZuev93zDGNPX+ySg_jeUg4Z3zKMcpABekUQvHA01kTVn4=A@mail.gmail.com>
 <CALCETrX=VmSjD6kLT6tuZQ4Efhc_13vZrw1mo4Z2iKqZTT-bzg@mail.gmail.com>
 <CAKOZuetu0QWUDAycTOFzC4HEbjH99EtOhb4gJnHAuovT_StpzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuetu0QWUDAycTOFzC4HEbjH99EtOhb4gJnHAuovT_StpzA@mail.gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, Mike Rapoport <rppt@linux.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Pavel Emelyanov <ovzxemul@gmail.com>, Tim Murray <timmurray@google.com>, Linux API <linux-api@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 05, 2019 at 08:06:49AM -0800, Daniel Colascione wrote:
> Sure, but the same argument applies to all the other permission checks
> that we do at open time, not at ioctl time. For better or for worse,
> the DAC-ish model used in most places is that access checks happen at
> file object creation time and anyone who has the FD can perform those
> operations later. Confusing the model by doing *some* permission
> checks at open time and *some* permission checks at usage time makes
> the system harder to understand.

The only case that requires change is if userland requested the
UFFD_FEATURE_EVENT_FORK feature (which AFIK only CRIU does) and that
request is done in the UFFDIO_API call not during the syscall.

Doing the check in the syscall would then break all non privileged
users like if we'd set /proc/sys/vm/unprivileged_userfaultfd to
zero. Qemu for example rightfully never runs with privilege (with a
few exceptions like Kata which should be fixed in fact) and it never
asks for the UFFD_FEATURE_EVENT_FORK feature either.
