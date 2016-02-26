From: Kazimierz Krosman <k.krosman-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v6 0/8] Additional kmsg devices
Date: Fri, 26 Feb 2016 14:22:42 +0100
Message-ID: <56D051A2.6050106@samsung.com>
References: <1456314801-32738-1-git-send-email-k.krosman@samsung.com>
 <20160225214714.GJ6092@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20160225214714.GJ6092-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org, vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, pmladek-AlSwsSmVLrQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, kay.sievers-tD+1rO4QERM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, knhoon.baik-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 02/25/2016 10:47 PM, Tejun Heo wrote:
> I'm not sure this is the right layer to implement generic logging
> facility.
In general this patches add only one feature- possibility of adding and 
deleting
new kmsg devices, so I think that it can be treated as kmsg upgrade.
>> 2. Using kmsg can cause lower CPU utilisation in the real-word use case than
>> >userspace logging mechanisms.
>> >We created 2 tests: (1) 100 writer processes write to created kmsg buffer and
>> >(2) 100 writers write to socket (stream)- there is one reader to protect
>> >socket buffer against overflow. Tests show that cpu utilisation in case of first
>> >test is about 2.3 times lower (39.1%) than it is in second case (87.7%) (measured
>> >with top program; tests code is attached below). Tested on Odroid XU4.
> This sounds like a generic IPC problem than anything else.

For the test purpose I've written two tests (attached in cover letter). 
I think that tests
show that in this use case (multiple writers) system with additional 
kmsg devices
consumes less CPU time than system which use sockets for logging. 
Logging system
based on sockets needs read process, that continuously reads socket and 
protects
against socket buffers overflow and messages drop. It is one of 
advantages of this
solution: no maintenance.

Could you explain in more detail what did you mean by IPC problems?

Thanks.

-- 
Kazimierz Krosman

Samsung R&D Institute Poland
Samsung Electronics
k.krosman-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org

  
