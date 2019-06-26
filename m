From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH V33 24/30] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
Date: Thu, 27 Jun 2019 06:22:47 +1000 (AEST)
Message-ID: <alpine.LRH.2.21.1906270621080.28132@namei.org>
References: <20190621011941.186255-1-matthewgarrett@google.com> <20190621011941.186255-25-matthewgarrett@google.com> <CALCETrVUwQP7roLnW6kFG80Cc5U6X_T6AW+BTAftLccYGp8+Ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CALCETrVUwQP7roLnW6kFG80Cc5U6X_T6AW+BTAftLccYGp8+Ow@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Matthew Garrett <matthewgarrett@google.com>, linux-security@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Matthew Garrett <mjg59@google.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Daniel Borkmann <daniel@iogearbox.net>, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

[Adding the LSM mailing list: missed this patchset initially]

On Thu, 20 Jun 2019, Andy Lutomirski wrote:

> This patch exemplifies why I don't like this approach:
> 
> > @@ -97,6 +97,7 @@ enum lockdown_reason {
> >         LOCKDOWN_INTEGRITY_MAX,
> >         LOCKDOWN_KCORE,
> >         LOCKDOWN_KPROBES,
> > +       LOCKDOWN_BPF,
> >         LOCKDOWN_CONFIDENTIALITY_MAX,
> 
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

Can you give an example of how the details might change?

> I'd be more comfortable if the LSM only got to see "confidentiality"
> or "integrity".

These are not sufficient for creating a useful policy for the SELinux 
case.

-- 
James Morris
<jmorris@namei.org>
