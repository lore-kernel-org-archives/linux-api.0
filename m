From: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 03/11] tracing/syscalls: add compat syscall metadata
Date: Wed, 12 Oct 2016 15:09:49 +0200
Message-ID: <f4ce7487-9285-c8a8-a3ed-32ec27034746@imgtec.com>
References: <1476182576-15247-1-git-send-email-marcin.nowakowski@imgtec.com>
 <1476182576-15247-4-git-send-email-marcin.nowakowski@imgtec.com>
 <8737k254tc.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8737k254tc.fsf-W0DJWXSxmBNbyGPkN3NxC2scP1bn1w/D@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 12.10.2016 10:50, Michael Ellerman wrote:
> <...>
> It's annoying that we have to duplicate all that just to do a + 1.
>
> How about this as a precursor?
 > <...>

Thanks for the suggestion - unless anyone sees a reason to keep the 
current solution I'll change it.

Marcin
