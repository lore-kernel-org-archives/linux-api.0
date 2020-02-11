From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH v4] mm: Add MREMAP_DONTUNMAP to mremap().
Date: Tue, 11 Feb 2020 15:13:50 -0800
Message-ID: <CAKOZuevHH1pamEKy5n5RLWDP=tHk6_9bR+g3G+HKnqm_srHvrw@mail.gmail.com>
References: <20200207201856.46070-1-bgeffon@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200207201856.46070-1-bgeffon@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brian Geffon <bgeffon@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Michael S . Tsirkin" <mst@redhat.com>, Arnd Bergmann <arnd@arndb.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Will Deacon <will@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Sonny Rao <sonnyrao@google.com>, Minchan Kim <minchan@kernel.org>, Joel Fernandes <joel@joelfernandes.org>, Yu Zhao <yuzhao@google.com>, Jesse Barnes <jsbarnes@google.com>, Nathan Chancellor <natechancellor@gmail.com>, Florian Weimer <fweimer@redhat.com>, "Kirill A . Shutemov" <kirill@shutemov.name>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 7, 2020 at 12:19 PM Brian Geffon <bgeffon@google.com> wrote:
>
> When remapping an anonymous, private mapping, if MREMAP_DONTUNMAP is
> set, the source mapping will not be removed. Instead it will be
> cleared as if a brand new anonymous, private mapping had been created
> atomically as part of the mremap() call.

The left-behind mapping (the "as if a brand new anonymous, private
mapping" map) is immediately writable, right? If so, we need to
account the additional commit charge. What about making the
left-behind mapping PROT_NONE? This way, we'll still solve the
address-space race in Lokesh's use case (because even a PROT_NONE
mapping reserves address space) but won't incur any additional commit
until someone calls mprotect(PROT_WRITE) on the left-behind mapping.
Imagine having two equal-sized mappings and wanting to use mremap() to
swap them: you can implement this swap by carving off a third region
of address space and making two mremap() calls. But without the
PROT_NONE, you pay additional commit for that third region even if you
don't need it.
