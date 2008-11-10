From: Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [RFC v9][PATCH 05/13] Dump memory address space
Date: Mon, 10 Nov 2008 15:34:37 -0500
Message-ID: <49189ADD.7030607@cs.columbia.edu>
References: <1226335060-7061-1-git-send-email-orenl@cs.columbia.edu> <1226335060-7061-6-git-send-email-orenl@cs.columbia.edu> <20081110201251.GA7471@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20081110201251.GA7471@us.ibm.com>
Sender: owner-linux-mm@kvack.org
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org


Serge E. Hallyn wrote:
> Quoting Oren Laadan (orenl@cs.columbia.edu):
>> +/**
>> + * cr_fill_fname - return pathname of a given file
>> + * @path: path name
>> + * @root: relative root
>> + * @buf: buffer for pathname
>> + * @n: buffer length (in) and pathname length (out)
>> + */
>> +static char *
>> +cr_fill_fname(struct path *path, struct path *root, char *buf, int *n)
>> +{
>> +	struct path tmp = *root;
>> +	char *fname;
>> +
>> +	BUG_ON(!buf);
>> +	fname = __d_path(path, &tmp, buf, *n);
>> +	if (!IS_ERR(fname))
>> +		*n = (buf + (*n) - fname);
>> +	/*
>> +	 * FIXME: if __d_path() changed these, it must have stepped out of
>> +	 * init's namespace. Since currently we require a unified namespace
>> +	 * within the container: simply fail.
>> +	 */
>> +	if (tmp.mnt != root->mnt || tmp.dentry != root->dentry)
>> +		fname = ERR_PTR(-EBADF);
>> +
>> +	return fname;
>> +}
> 
> You still are not taking the dcache_lock around __d_path.
> 

You still are right.

Oren.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
