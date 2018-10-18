From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [PATCH 2/3] uapi: get rid of STATX_ALL
Date: Thu, 18 Oct 2018 15:15:34 +0200
Message-ID: <875zxzxuo9.fsf@mid.deneb.enyo.de>
References: <20181018131125.6303-1-mszeredi@redhat.com>
        <20181018131125.6303-2-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181018131125.6303-2-mszeredi@redhat.com> (Miklos Szeredi's
        message of "Thu, 18 Oct 2018 15:11:24 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org

* Miklos Szeredi:

>  #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */

What about this?  Isn't it similar to STATX_ALL in the sense that we
don't know yet what it will mean?
