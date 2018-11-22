From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH v2] Add /proc/pid_gen
Date: Thu, 22 Nov 2018 16:58:34 +0300
Message-ID: <20181122135834.GA29449@uranus>
References: <20181121201452.77173-1-dancol@google.com>
 <20181121205428.165205-1-dancol@google.com>
 <20181121141220.0e533c1dcb4792480efbf3ff@linux-foundation.org>
 <CAKOZuetW6WMNFdL5_2=UbrEf8mjxYTdz1+4BiRLSgdoKh8FsqQ@mail.gmail.com>
 <20181121145043.fa029f4f91afddc2a10bb81e@linux-foundation.org>
 <CAKOZuesF5zi9mpEE6No7oq0hDnM8KFhQFU=NM7qUF635s0r3-A@mail.gmail.com>
 <37255927-1A93-4B8B-A916-B5A3983D56B6@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <37255927-1A93-4B8B-A916-B5A3983D56B6@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Colascione <dancol@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Primiano Tucci <primiano@google.com>, Joel Fernandes <joelaf@google.com>, Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>, Prashant Dhamdhere <pdhamdhe@redhat.com>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, rostedt@goodmis.org, tglx@linutronix.de, mingo@kernel.org, linux@dominikbrodowski.net, jpoimboe@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Stephen Rothwell <sfr@canb.auug.o>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 21, 2018 at 04:35:34PM -0700, Andy Lutomirski wrote:
> > 
> > I'm going to have Android's systrace and Perfetto use this approach.
> > Exactly how many tools signed up to use this feature do you need?
> > 
> >> Those people are the intended audience and the
> >> best-positioned reviewers so let's hear from them?
> > 
> > I'm writing plenty of trace analysis tools myself, so I'm part of this
> > intended audience. Other tracing tool authors have told me about
> > out-of-tree hacks for process atomic snapshots via ftrace events. This
> > approach avoids the necessity of these more-invasive hacks.
> 
> Would a tracepoint for pid reuse solve your problem?

FWIW we've had similar problem in criu for memory snapshotting,
because memory data is PID-driven and snapshots are rather
discrete events. So we use task_struct::real_start_time as
a second guard agains pid reuse.
