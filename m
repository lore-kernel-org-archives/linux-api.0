From: Cedric Le Goater <clg-NmTC/0ZBporQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v7][PATCH 0/9] Kernel based checkpoint/restart
Date: Wed, 22 Oct 2008 13:55:38 +0200
Message-ID: <48FF14BA.6050807@fr.ibm.com>
References: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu>
	<20081021122135.4bce362c.akpm@linux-foundation.org>
	<1224621667.1848.228.camel@nimitz> <20081022092024.GC12453@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20081022092024.GC12453-X9Un+BFzKDI@public.gmane.org>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/containers>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Ingo Molnar wrote:
> * Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> 
>> On Tue, 2008-10-21 at 12:21 -0700, Andrew Morton wrote:
>>> On Mon, 20 Oct 2008 01:40:28 -0400
>>> Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org> wrote:
>>>> These patches implement basic checkpoint-restart [CR]. This version
>>>> (v7) supports basic tasks with simple private memory, and open files
>>>> (regular files and directories only).
>>> - how useful is this code as it stands in real-world usage?
>> Right now, an application must be specifically written to use these 
>> mew system calls.  It must be a single process and not share any 
>> resources with other processes.  The only file descriptors that may be 
>> open are simple files and may not include sockets or pipes.
>>
>> What this means in practice is that it is useful for a simple app 
>> doing computational work.
> 
> say a chemistry application doing calculations. Or a raytracer with a 
> large job. Both can take many hours (days!) even on very fast machine 

even weeks in the EDA and Petroleum geophysics.

> and the restrictions on rebootability can hurt in such cases.

yes, indeed. 

These industries also like to be able to schedule high priority jobs
needing the full power of their clusters: checkpoint running jobs,
schedule a high priority one, restart the previous.

> You should reach a minimal level of initial practical utility: say some 
> helper tool that allows testers to checkpoint and restore a real PovRay 
> session - without any modification to a stock distro PovRay.

Supporting Povray is a good target. many HPC applications have the same 
resource  scope.  

C.
