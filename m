From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: Re: [PATCH 0/1] ns: introduce proc_get_ns_by_fd()
Date: Mon, 28 Sep 2015 11:21:07 +0300
Message-ID: <5608F873.6050305@yandex-team.ru>
References: <20150925135246.27620.97496.stgit@buzz>
 <20150925175654.GA12504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150925175654.GA12504-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Chen Fan <chen.fan.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?Q?St=c3=a9phane_Graber?= <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 25.09.2015 20:56, Oleg Nesterov wrote:
> On 09/25, Konstantin Khlebnikov wrote:
>>
>> +struct ns_common *proc_ns_fdget(int fd, int nstype, struct fd *fd_ref)
>>   {
>> -	struct file *file;
>> +	struct ns_common *ns;
>> +	struct fd f;
>>
>> -	file = fget(fd);
>> -	if (!file)
>> +	f = fdget(fd);
>> +	if (!f.file)
>>   		return ERR_PTR(-EBADF);
>>
>> -	if (file->f_op != &ns_file_operations)
>> +	if (f.file->f_op != &ns_file_operations)
>> +		goto out_invalid;
>> +
>> +	ns = get_proc_ns(file_inode(f.file));
>> +	if (nstype && (ns->ops->type != nstype))
>>   		goto out_invalid;
>>
>> -	return file;
>> +	*fd_ref = f;
>> +	return ns;
>>
>>   out_invalid:
>> -	fput(file);
>> +	fdput(f);
>>   	return ERR_PTR(-EINVAL);
>>   }
>
> Well yes, fdget() makes sense but this is minor.
>
> Honestly, I do not really like the new helper... I understand this
> is subjective, so I won't insist. But how about 1/1? We do not need
> fd/file at all. With this patch your sys_getvpid() can just use
> proc_get_ns_by_fd(fd, CLONE_NEWPID) and put_pid_ns().

Hmm. My version has 0 or 2 atomic ops per get-put sequence.
Your version: 2 or 4 atomic ops. Plus even in worst case pinning by
struct fd theoretically scales better because it touches refcount at
struct file: there're might be many of them for one namespace.

>
> Eric, what do you think?
>
> See also "TODO" in the changelog.
>
> Oleg.
>


-- 
Konstantin
