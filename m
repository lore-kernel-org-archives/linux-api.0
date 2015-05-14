From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 0/3] Allow user to request memory to be locked on page
 fault
Date: Thu, 14 May 2015 10:08:12 +0200
Message-ID: <20150514080812.GC6433@dhcp22.suse.cz>
References: <1431113626-19153-1-git-send-email-emunson@akamai.com>
 <20150508124203.6679b1d35ad9555425003929@linux-foundation.org>
 <20150511180631.GA1227@akamai.com>
 <20150513150036.GG1227@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150513150036.GG1227-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, linux-parisc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xtensa-PjhNF2WwrV/0Sa2dR60CXw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 13-05-15 11:00:36, Eric B Munson wrote:
> On Mon, 11 May 2015, Eric B Munson wrote:
> 
> > On Fri, 08 May 2015, Andrew Morton wrote:
> > 
> > > On Fri,  8 May 2015 15:33:43 -0400 Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:
> > > 
> > > > mlock() allows a user to control page out of program memory, but this
> > > > comes at the cost of faulting in the entire mapping when it is
> > > > allocated.  For large mappings where the entire area is not necessary
> > > > this is not ideal.
> > > > 
> > > > This series introduces new flags for mmap() and mlockall() that allow a
> > > > user to specify that the covered are should not be paged out, but only
> > > > after the memory has been used the first time.
> > > 
> > > Please tell us much much more about the value of these changes: the use
> > > cases, the behavioural improvements and performance results which the
> > > patchset brings to those use cases, etc.
> > > 
> > 
> > To illustrate the proposed use case I wrote a quick program that mmaps
> > a 5GB file which is filled with random data and accesses 150,000 pages
> > from that mapping.  Setup and processing were timed separately to
> > illustrate the differences between the three tested approaches.  the
> > setup portion is simply the call to mmap, the processing is the
> > accessing of the various locations in  that mapping.  The following
> > values are in milliseconds and are the averages of 20 runs each with a
> > call to echo 3 > /proc/sys/vm/drop_caches between each run.
> > 
> > The first mapping was made with MAP_PRIVATE | MAP_LOCKED as a baseline:
> > Startup average:    9476.506
> > Processing average: 3.573
> > 
> > The second mapping was simply MAP_PRIVATE but each page was passed to
> > mlock() before being read:
> > Startup average:    0.051
> > Processing average: 721.859
> > 
> > The final mapping was MAP_PRIVATE | MAP_LOCKONFAULT:
> > Startup average:    0.084
> > Processing average: 42.125
> > 
> 
> Michal's suggestion of changing protections and locking in a signal
> handler was better than the locking as needed, but still significantly
> more work required than the LOCKONFAULT case.
> 
> Startup average:    0.047
> Processing average: 86.431

Have you played with batching? Has it helped? Anyway it is to be
expected that the overhead will be higher than a single mmap call. The
question is whether you can live with it because adding a new semantic
to mlock sounds trickier and MAP_LOCKED is tricky enough already...

-- 
Michal Hocko
SUSE Labs
