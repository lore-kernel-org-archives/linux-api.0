From: Daniel Lezcano <daniel.lezcano-GANU6spQydw@public.gmane.org>
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
Date: Tue, 29 Sep 2009 15:29:28 +0200
Message-ID: <4AC20BB8.4070509@free.fr>
References: <1253749920-18673-1-git-send-email-orenl@librato.com>	<20090924154139.2a7dd5ec.akpm@linux-foundation.org> <20090928163704.GA3327@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090928163704.GA3327-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Andrew Morton (akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org):
>   
>> On Wed, 23 Sep 2009 19:50:40 -0400
>> Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org> wrote:
>>     
>>> Q: What about namespaces ?
>>> A: Currrently, UTS and IPC namespaces are restored. They demonstrate
>>>    how namespaces are handled. More to come.
>>>       
>> Will this new code muck up the kernel?
>>     

[ cut ]
> For network namespaces i think it's clearer that a wrapper
> program should set up the network for the restarted init task,
> while the usrspace code should recreate any private network
> namespaces and veth's which were created by the application.
> But it still needs discussion.
>   
Ok for the restart, but for the checkpoint, how do you access the 
network setup from a process which belongs to another namespace context ?

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
