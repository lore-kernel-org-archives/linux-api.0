From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V33 24/30] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
Date: Fri, 21 Jun 2019 13:05:44 -0700
Message-ID: <CACdnJuv2sePuGBtTM6UL4S2k1UATcAk517o6vPx2EWF0Uxt8iw@mail.gmail.com>
References: <20190621011941.186255-1-matthewgarrett@google.com>
 <20190621011941.186255-25-matthewgarrett@google.com> <CALCETrVUwQP7roLnW6kFG80Cc5U6X_T6AW+BTAftLccYGp8+Ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CALCETrVUwQP7roLnW6kFG80Cc5U6X_T6AW+BTAftLccYGp8+Ow@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: James Morris <jmorris@namei.org>, linux-security@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Daniel Borkmann <daniel@iogearbox.net>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 20, 2019 at 10:22 PM Andy Lutomirski <luto@kernel.org> wrote:
> On Thu, Jun 20, 2019 at 6:21 PM Matthew Garrett
> <matthewgarrett@google.com> wrote:
> > --- a/security/lockdown/lockdown.c
> > +++ b/security/lockdown/lockdown.c
> > @@ -33,6 +33,7 @@ static char *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
> >         [LOCKDOWN_INTEGRITY_MAX] = "integrity",
> >         [LOCKDOWN_KCORE] = "/proc/kcore access",
> >         [LOCKDOWN_KPROBES] = "use of kprobes",
> > +       [LOCKDOWN_BPF] = "use of bpf",
> >         [LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
>
> The text here says "use of bpf", but what this patch is *really* doing
> is locking down use of BPF to read kernel memory.  If the details
> change, then every LSM needs to get updated, and we risk breaking user
> policies that are based on LSMs that offer excessively fine
> granularity.

The text is descriptive rather than normative, and no changes should
be made that alter the semantics of a reason - it makes more sense to
just add another reason.

> I'd be more comfortable if the LSM only got to see "confidentiality"
> or "integrity".

If LSM authors can be trusted to do the right thing here, then I see
no problem in providing additional data. I'm happy to defer to James
on that.
