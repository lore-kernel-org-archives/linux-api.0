From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC v17][PATCH 10/60] c/r: make file_pos_read/write() public
Date: Thu, 23 Jul 2009 11:33:20 +0900
Message-ID: <20090723113320.65f6746d.kamezawa.hiroyu@jp.fujitsu.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com>
	<1248256822-23416-11-git-send-email-orenl@librato.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1248256822-23416-11-git-send-email-orenl@librato.com>
Sender: owner-linux-mm@kvack.org
To: Oren Laadan <orenl@librato.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org, Linus Torvalds <torvalds@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>, Pavel Emelyanov <xemul@openvz.org>
List-Id: linux-api@vger.kernel.org

a nitpick.

On Wed, 22 Jul 2009 05:59:32 -0400
Oren Laadan <orenl@librato.com> wrote:

> These two are used in the next patch when calling vfs_read/write()

> +static inline loff_t file_pos_read(struct file *file)
> +{
> +	return file->f_pos;
> +}
> +
> +static inline void file_pos_write(struct file *file, loff_t pos)
> +{
> +	file->f_pos = pos;
> +}
> +

I'm not sure but how about renaming this to
	file_pos() 
	set_file_pos()
at moving this to global include file ?

Thanks,
-Kame

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
