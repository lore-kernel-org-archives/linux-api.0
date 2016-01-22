From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/1] seccomp: provide information about the previous
 syscall
Date: Fri, 22 Jan 2016 09:30:50 -0800
Message-ID: <20160122173050.GE9608@ast-mbp.thefacebook.com>
References: <1453444200-8604-1-git-send-email-daniel.sangorrin@toshiba.co.jp>
 <1453444200-8604-2-git-send-email-daniel.sangorrin@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1453444200-8604-2-git-send-email-daniel.sangorrin-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Sangorrin <daniel.sangorrin-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org>
Cc: keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 22, 2016 at 03:30:00PM +0900, Daniel Sangorrin wrote:
> This patch allows applications to restrict the order in which
> its system calls may be requested. In order to do that, we
> provide seccomp-BPF scripts with information about the
> previous system call requested.
> 
> An example use case consists of detecting (and stopping) return
> oriented attacks that disturb the normal execution flow of
> a user program.
> 
> Signed-off-by: Daniel Sangorrin <daniel.sangorrin-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org>
...
> diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
...
>  struct seccomp_data {
>  	int nr;
> +	int prev_nr;
>  	__u32 arch;
>  	__u64 instruction_pointer;
>  	__u64 args[6];

this will break abi for existing seccomp programs.
New field has to be at the end.
