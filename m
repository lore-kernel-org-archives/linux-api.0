From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH RESEND] UAPI: move RENAME_* definitions to separated file
Date: Tue, 13 Nov 2018 12:09:40 +0100
Message-ID: <878t1xkzd7.fsf@oldenburg.str.redhat.com>
References: <20181113085102.3079-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181113085102.3079-1-ynorov@caviumnetworks.com> (Yury Norov's
        message of "Tue, 13 Nov 2018 08:51:12 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "Norov, Yuri" <Yuri.Norov@cavium.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

* Yury Norov:

> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 53a22e8e0408..dbf58bbf5bad 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h

Could you move it to a dedicated <linux/rename-flags.h> header?  Or add
a comment that the header is only for rename flags?

Then we can change glibc to include it if it is present and when
compiling under _GNU_SOURCE.

Thanks,
Florian
