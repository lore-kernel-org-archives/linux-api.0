From: Steven Stewart-Gallus <sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org>
Subject: execve is not atomic, what is the exit state of the process when
 execve fails after throwing away the original process image?
Date: Fri, 02 May 2014 02:19:52 +0000 (GMT)
Message-ID: <faa2c0e82f8a8.536300c8@langara.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-disposition: inline
Content-language: en
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello, can any kernel gurus please help me out with what happens on this weird
corner-case?


Quoting Rich Felker at http://ewontfix.com/14/:

> For common reasons it might fail, the execve syscall returns failure
> in the original process image, allowing the program to handle the
> error. However, failure of execve is not entirely atomic:
> 
>     The kernel may fail setting up the VM for the new process image
>     after the original VM has already been destroyed; the main
>     situation under which this would happen is resource exhaustion.
> 
>     Even after the kernel successfully sets up the new VM and
>     transfers execution to the new process image, it's possible to
>     have failures prior to the transfer of control to the actual
>     application program. This could happen in the dynamic linker
>     (resource exhaustion or other transient failures mapping required
>     libraries or loading configuration files) or libc startup
>     code. Using musl libc with static linking or even dynamic linking
>     with no additional libraries eliminates these failure cases, but
>     systemd is intended to be used with glibc.

execve is not atomic, what is the exit state of the process when
execve fails after throwing away the original process image?

I already have a hacky solution (see
https://gitorious.org/linted/linted/source/d25eac7a6fb58946ec8112771c0c56eb39fd1055:src/spawn/spawn.c)
to finding when a process fails before or at execve and now I want to
know what exit status is returned so I can give a nice error message.
