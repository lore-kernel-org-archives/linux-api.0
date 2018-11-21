From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH] Add /proc/pid_generation
Date: Wed, 21 Nov 2018 12:38:20 -0800
Message-ID: <CAKOZueuCYOsaHZzoz5nNPr8Jb-fEiHTR4MektaJx8vuUXcrKCQ@mail.gmail.com>
References: <20181121201452.77173-1-dancol@google.com> <20181121203150.GK3065@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181121203150.GK3065@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Primiano Tucci <primiano@google.com>, Joel Fernandes <joelaf@google.com>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Roman Gushchin <guro@fb.com>, Vlastimil Babka <vbabka@suse.cz>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Prashant Dhamdhere <pdhamdhe@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, rostedt@goodmis.org, tglx@linutronix.de, mingo@kernel.org, linux@dominikbrodowski.net, pasha.tatashin@oracle.com, jpoimboe@redhat.com, ard.biesheuvel@linaro.org, Michal Hocko <mhocko@suse.com>, David Howells <dhowells@redhat.com>, ktsanaktsidis@zendesk.com
List-Id: linux-api@vger.kernel.org

On Wed, Nov 21, 2018 at 12:31 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Wed, Nov 21, 2018 at 12:14:44PM -0800, Daniel Colascione wrote:
> > This change adds a per-pid-namespace 64-bit generation number,
> > incremented on PID rollover, and exposes it via a new proc file
> > /proc/pid_generation. By examining this file before and after /proc
> > enumeration, user code can detect the potential reuse of a PID and
> > restart the task enumeration process, repeating until it gets a
> > coherent snapshot.
> >
> > PID rollover ought to be rare, so in practice, scan repetitions will
> > be rare.
>
> Then why does it need to be 64-bit?

[Resending because of accidental HTML. I really need to switch to a
better email client.]

Because 64 bits is enough for anyone. :-) A u64 is big enough that
we'll never observe an overflow on a running system, and PID
namespaces are rare enough that we won't miss the four extra bytes we
use by upgrading from a u32.  And after reading about some security
problems caused by too-clever handling of 32-bit rollover, I'd rather
the code be obviously correct than save a trivial amount of space.
