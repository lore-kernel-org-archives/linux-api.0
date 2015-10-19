From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC v3 6/9] kmsg: add ioctl for adding and deleting kmsg* devices
Date: Mon, 19 Oct 2015 15:19:25 +0200
Message-ID: <5057964.QyIB3GKfsB@wuerfel>
References: <1445259503-18158-1-git-send-email-p.osmialowsk@samsung.com> <1445259503-18158-7-git-send-email-p.osmialowsk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1445259503-18158-7-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: Paul Osmialowski <p.osmialowsk@samsung.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Kay Sievers <kay.sievers@vrfy.org>, Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, Marcin Niesluchowski <m.niesluchow@samsung.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On Monday 19 October 2015 14:58:20 Paul Osmialowski wrote:
> +
> +struct kmsg_cmd_buffer_add {
> +       size_t size;
> +       unsigned short mode;
> +       int minor;
> +} __attribute__((packed));
> +
> +#define KMSG_IOCTL_MAGIC       0xBB
> +
> +/*
> 

Try to avoid using packed unaligned data structures. Here I would
just use __u64 and __u32 members.

> +       case KMSG_CMD_BUFFER_ADD:
> +               if (copy_from_user(&size, argp, sizeof(size)))
> +                       return -EFAULT;
> +               argp += sizeof(size);
> +               if (copy_from_user(&mode, argp, sizeof(mode)))
> +                       return -EFAULT;

This is a rather unusual way to access the data. Just copy the
entire structure to the stack.

	Arnd
