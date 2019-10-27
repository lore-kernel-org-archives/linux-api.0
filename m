From: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user mappings
Date: Sun, 27 Oct 2019 13:00:13 +0200
Message-ID: <385EB6D4-A1B0-4617-B256-181AA1C3BDE3@kernel.org>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org> <87d0eieb0i.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87d0eieb0i.fsf@mid.deneb.enyo.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-api@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

On October 27, 2019 12:30:21 PM GMT+02:00, Florian Weimer <fw@deneb=2Eenyo=
=2Ede> wrote:
>* Mike Rapoport:
>
>> The patch below aims to allow applications to create mappins that
>have
>> pages visible only to the owning process=2E Such mappings could be used
>to
>> store secrets so that these secrets are not visible neither to other
>> processes nor to the kernel=2E
>
>How is this expected to interact with CRIU?

CRIU dumps the memory contents using a parasite code from inside the dumpe=
e address space, so it would work the same way as for the other mappings=2E=
 Of course, at the restore time the exclusive mapping should be recreated w=
ith the appropriate flags=2E

>> I've only tested the basic functionality, the changes should be
>verified
>> against THP/migration/compaction=2E Yet, I'd appreciate early feedback=
=2E
>
>What are the expected semantics for VM migration?  Should it fail?

I don't quite follow=2E If qemu would use such mappings it would be able t=
o transfer them during live migration=2E

--=20
Sincerely yours,
Mike
