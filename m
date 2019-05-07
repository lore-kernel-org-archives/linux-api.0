From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: [PATCH] uapi: avoid namespace conflict in linux/posix_types.h
Date: Tue, 7 May 2019 22:50:49 +0000
Message-ID: <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
References: <20190319165123.3967889-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190319165123.3967889-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-api@vger.kernel.org, linux-arch@vger.kernel.org, netdev@vger.kernel.org, Laura Abbott <labbott@redhat.com>, Florian Weimer <fw@deneb.enyo.de>, Paul Burton <pburton@wavecomp.com>, Deepa Dinamani <deepa.kernel@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

What happened with this patch (posted 19 March)?  I found today that we 
can't use Linux 5.1 headers in glibc testing because the namespace issues 
are still present in the headers as of the release.

-- 
Joseph S. Myers
joseph@codesourcery.com
