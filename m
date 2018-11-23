From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] Add /proc/pid_generation
Date: Fri, 23 Nov 2018 11:14:17 +0000
Message-ID: <f00df51af0a4491fa7d86f9dc0c07bf6@AcuMS.aculab.com>
References: <20181121201452.77173-1-dancol@google.com>
 <20181122111930.GA7164@ip-172-31-15-78>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181122111930.GA7164@ip-172-31-15-78>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Kevin Easton' <kevin@guarana.org>, Daniel Colascione <dancol@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "timmurray@google.com" <timmurray@google.com>, "primiano@google.com" <primiano@google.com>, "joelaf@google.com" <joelaf@google.com>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Roman Gushchin <guro@fb.com>, Vlastimil Babka <vbabka@suse.cz>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Prashant Dhamdhere <pdhamdhe@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Steven Rostedt (VMware)" <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Pavel
List-Id: linux-api@vger.kernel.org

From: Kevin Easton
> Sent: 22 November 2018 11:20
> 
> On Wed, Nov 21, 2018 at 12:14:44PM -0800, Daniel Colascione wrote:
> > This change adds a per-pid-namespace 64-bit generation number,
> > incremented on PID rollover, and exposes it via a new proc file
> > /proc/pid_generation. By examining this file before and after /proc
> > enumeration, user code can detect the potential reuse of a PID and
> > restart the task enumeration process, repeating until it gets a
> > coherent snapshot.
> 
> I see downthread this patch has been withdrawn, but nonetheless I'm
> still curious - does this actually solve the problem?
> 
> It seems to me that a PID could be reused within a scan even if the
> generation number remains the same at the beginning and end of a scan:

Why not allocate a 48bit generation number to each 16bit pid?
Then you have a 64bit 'extended-pid' that can be assumed to never be reused.
Provided enough interfaces are enhanced to support 'extended-pid' values
you'll never get reused values.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
