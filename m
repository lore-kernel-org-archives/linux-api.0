From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 01/10] security: Override creds in __fput() with last
 fputter's creds [ver #3]
Date: Thu, 6 Jun 2019 12:34:00 -0700
Message-ID: <CALCETrVc=PpCjSC-pjcjr0WMKtgVXWijwB3FX+tSp5VOH2bCpg@mail.gmail.com>
References: <155981411940.17513.7137844619951358374.stgit@warthog.procyon.org.uk>
 <155981413016.17513.10540579988392555403.stgit@warthog.procyon.org.uk>
 <176F8189-3BE9-4B8C-A4D5-8915436338FB@amacapital.net> <11031.1559833574@warthog.procyon.org.uk>
 <CALCETrUukxNNhbBAifxz1EADzLOvYKoh9oqqZFJteU+MMhh1ig@mail.gmail.com> <e434a62a-d92a-c6e2-cda1-309ac99d4d5c@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e434a62a-d92a-c6e2-cda1-309ac99d4d5c@schaufler-ca.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 6, 2019 at 12:09 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> On 6/6/2019 10:18 AM, Andy Lutomirski wrote:
> > On Thu, Jun 6, 2019 at 8:06 AM David Howells <dhowells@redhat.com> wrote:
> >> Andy Lutomirski <luto@amacapital.net> wrote:

> > Casey, I think you need to state your requirement in a way that's well
> > defined, and I think you need to make a compelling case that your
> > requirement is indeed worth dictating the design of parts of the
> > kernel outside LSM.
>
> Err, no, I don't believe so. There's a whole lot more
> going on in this discussion than just what's going on
> within the LSMs. Using examples from the LSMs makes it
> easier, because their policies are better defined than
> the "legacy" policies are. The most important part of the
> discussion is about ensuring that the event mechanism
> doesn't circumvent the legacy policies. Yes, I understand
> that you don't know what that means, or has to do with
> anything.
>
>

Indeed, I do not know what you have in mind about making sure this
mechanism doesn't circumvent legacy policies.  Can you elaborate?

--Andy
