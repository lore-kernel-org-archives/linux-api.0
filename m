From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] Add /proc/pid_gen
Date: Wed, 21 Nov 2018 17:29:19 -0800
Message-ID: <20181121172919.1b6585e17770d0be7dd8c4d9@linux-foundation.org>
References: <20181121201452.77173-1-dancol@google.com>
        <20181121205428.165205-1-dancol@google.com>
        <20181121141220.0e533c1dcb4792480efbf3ff@linux-foundation.org>
        <CAKOZuetW6WMNFdL5_2=UbrEf8mjxYTdz1+4BiRLSgdoKh8FsqQ@mail.gmail.com>
        <20181121145043.fa029f4f91afddc2a10bb81e@linux-foundation.org>
        <CAKOZuesF5zi9mpEE6No7oq0hDnM8KFhQFU=NM7qUF635s0r3-A@mail.gmail.com>
        <20181121162247.467fcab6c0aca0819a822286@linux-foundation.org>
        <CAKOZuet7ipw8zoXCDQUB5PKs3kdSye-zesBbEv7jVDSByhXgkw@mail.gmail.com>
        <20181121165741.ef089df784482632c4a66370@linux-foundation.org>
        <CAKOZuessQgmPuiReEO0caNqkss=r44o-XXnem12TOXSn=y6xkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuessQgmPuiReEO0caNqkss=r44o-XXnem12TOXSn=y6xkw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Primiano Tucci <primiano@google.com>, Joel Fernandes <joelaf@google.com>, Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>, Prashant Dhamdhere <pdhamdhe@redhat.com>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, rostedt@goodmis.org, tglx@linutronix.de, mingo@kernel.org, linux@dominikbrodowski.net, jpoimboe@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Stephen Rothwell <sfr@canb.auug.org.au>, ktsanaktsidis@zendesk.com, David Howells <dhowells@redhat.com>, open list
List-Id: linux-api@vger.kernel.org

On Wed, 21 Nov 2018 17:08:08 -0800 Daniel Colascione <dancol@google.com> wrote:

> Have you done much
> retrospective long trace analysis?

No.  Have you?

Of course you have, which is why I and others are dependent upon you to
explain why this change is worth adding to Linux.  If this thing solves
a problem which we expect will not occur for anyone between now and the
heat death of the universe then this impacts our decisions.

> The patch already describes the problem, the solution, and the way in
> which this solution is provided. What more information do you want?

I want to know how useful the darn thing is!  Why is this so hard?

And my thus-far-unanswered question regarding testing the feature
is also relevant to that understanding.  What does a testcase look
like?  If we're not actually able to construct one then what does that
mean?
