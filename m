From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH v2] Add /proc/pid_gen
Date: Wed, 21 Nov 2018 14:52:40 -0800
Message-ID: <CAKOZuetQPAKKxsZw2ExAsUdiRfSm-rVonqLD86vs1bnwyW1+pg@mail.gmail.com>
References: <20181121201452.77173-1-dancol@google.com> <20181121205428.165205-1-dancol@google.com>
 <20181121141220.0e533c1dcb4792480efbf3ff@linux-foundation.org>
 <CAKOZuetW6WMNFdL5_2=UbrEf8mjxYTdz1+4BiRLSgdoKh8FsqQ@mail.gmail.com> <CAG48ez3kgFC74jTmxqL5aPgmqcN-W4E9bR7Fz3V=Vt4qkpx2Pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez3kgFC74jTmxqL5aPgmqcN-W4E9bR7Fz3V=Vt4qkpx2Pg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Primiano Tucci <primiano@google.com>, Joel Fernandes <joelaf@google.com>, Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>, Prashant Dhamdhere <pdhamdhe@redhat.com>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, rostedt@goodmis.org, tglx@linutronix.de, mingo@kernel.org, linux@dominikbrodowski.net, jpoimboe@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, sfr@canb.auug.org.au, ktsanaktsidis@zendesk.com, David Howells <dhowells@redhat.>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 21, 2018 at 2:49 PM Jann Horn <jannh@google.com> wrote:
>
> On Wed, Nov 21, 2018 at 11:40 PM Daniel Colascione <dancol@google.com> wrote:
> > On Wed, Nov 21, 2018 at 2:12 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Wed, 21 Nov 2018 12:54:20 -0800 Daniel Colascione <dancol@google.com> wrote:
> > > > +u64 read_pid_generation(struct pid_namespace *ns)
> > > > +{
> > > > +     u64 generation;
> > > > +
> > > > +
> > > > +     spin_lock_irq(&pidmap_lock);
> > > > +     generation = ns->generation;
> > > > +     spin_unlock_irq(&pidmap_lock);
> > > > +     return generation;
> > > > +}
> > >
> > > What is the spinlocking in here for?  afaict the only purpose it serves
> > > is to make the 64-bit read atomic, so it isn't needed on 32-bit?
> >
> > ITYM the spinlock is necessary *only* on 32-bit, since 64-bit
> > architectures have atomic 64-bit reads, and 64-bit reads on 32-bit
> > architectures can tear. This function isn't a particularly hot path,
> > so I thought consistency across architectures would be more valuable
> > than avoiding the lock on some systems.
>
> Linux has atomic64_t/atomic64_read()/atomic64_inc() for this, which
> should automatically do the right thing - processor-supported atomic
> ops when possible, spinlock otherwise.

I wanted to take advantage of the existing spinlock to synchronize
instead of adding more atomic operations to the rollover path.
