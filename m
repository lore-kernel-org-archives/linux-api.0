From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 10/10] Add sample notification program [ver #3]
Date: Fri, 07 Jun 2019 15:37:49 +0100
Message-ID: <17511.1559918269@warthog.procyon.org.uk>
References: <20190606212140.GA25664@vmlxhi-102.adit-jv.com> <155981411940.17513.7137844619951358374.stgit@warthog.procyon.org.uk> <155981421379.17513.13158528501056454772.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190606212140.GA25664@vmlxhi-102.adit-jv.com>
Content-ID: <17510.1559918269.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Eugeniu Rosca <erosca@de.adit-jv.com>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Eugeniu Rosca <roscaeugeniu@gmail.com>
List-Id: linux-api@vger.kernel.org

Eugeniu Rosca <erosca@de.adit-jv.com> wrote:

> > +			asm ("lfence" : : : "memory" );
> [..]
> > +			asm("mfence" ::: "memory");

Have a look at ver #4.

David
