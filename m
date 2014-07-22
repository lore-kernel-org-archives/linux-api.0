From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH -v4] random: introduce getrandom(2) system call
Date: Tue, 22 Jul 2014 16:36:05 +0200
Message-ID: <5099206.RVhAB5vDXY@devpool02>
References: <1405718127-30042-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405718127-30042-1-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-crypto@vger.kernel.org, beck@openbsd.org, deraadt@cvs.openbsd.org
List-Id: linux-api@vger.kernel.org

> 	EAGAIN		The requested entropy was not available, and the
> 			getentropy(2) would have blocked if GRND_BLOCK flag
> 			was set.

I think either "and the call to getentropy(2)" or "and getentropy(2)" here.

Greetings,

Eike
