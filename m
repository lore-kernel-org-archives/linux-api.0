From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] uapi: avoid namespace conflict in linux/posix_types.h
Date: Fri, 07 Jun 2019 06:28:09 +0200
Message-ID: <87tvd2j9ye.fsf@oldenburg2.str.redhat.com>
References: <20190319165123.3967889-1-arnd@arndb.de>
        <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
        (Joseph Myers's message of "Tue, 7 May 2019 22:50:49 +0000")
Sender: netdev-owner@vger.kernel.org
To: Joseph Myers <joseph@codesourcery.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, netdev@vger.kernel.org, Laura Abbott <labbott@redhat.com>, Paul Burton <pburton@wavecomp.com>, Deepa Dinamani <deepa.kernel@gmail.com>, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
List-Id: linux-api@vger.kernel.org

* Joseph Myers:

> What happened with this patch (posted 19 March)?  I found today that we 
> can't use Linux 5.1 headers in glibc testing because the namespace issues 
> are still present in the headers as of the release.

This regression fix still hasn't been merged into Linus' tree.  What is
going on here?

This might seem rather minor, but the namespace testing is actually
relevant in practice.  It prevents accidental clashes with C/C++
identifiers in user code.

If this fairly central UAPI header is not made namespace-clean again,
then we need to duplicate information from more UAPI headers in glibc,
and I don't think that's something we'd want to do.

Thanks,
Florian
