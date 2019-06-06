From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 01/10] security: Override creds in __fput() with last fputter's creds [ver #3]
Date: Thu, 06 Jun 2019 16:06:14 +0100
Message-ID: <11031.1559833574@warthog.procyon.org.uk>
References: <176F8189-3BE9-4B8C-A4D5-8915436338FB@amacapital.net> <155981411940.17513.7137844619951358374.stgit@warthog.procyon.org.uk> <155981413016.17513.10540579988392555403.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <176F8189-3BE9-4B8C-A4D5-8915436338FB@amacapital.net>
Content-ID: <11030.1559833574.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, Casey Schaufler <casey@schaufler-ca.com>, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> wrote:

> > So that the LSM can see the credentials of the last process to do an fput()
> > on a file object when the file object is being dismantled, do the following
> > steps:
> > 
> 
> I still maintain that this is a giant design error.

Yes, I know.  This was primarily a post so that Greg could play with the USB
notifications stuff I added.  The LSM support isn't resolved and is unchanged.

> Can someone at least come up with a single valid use case that isn't
> entirely full of bugs?

"Entirely full of bugs"?

How would you propose I deal with Casey's requirement?  I'm getting the
feeling you're going to nak it if I try to fulfil that and he's going to nak
it if I don't.

David
