From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
Subject: Suggestion, "public process scoped interfaces"
Date: Wed, 02 Apr 2014 19:03:02 +0000 (GMT)
Message-ID: <fa9ecac225ee2.533c5ee6@langara.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <owner-linux-mm@kvack.org>
Content-disposition: inline
Content-language: en
Sender: owner-linux-mm@kvack.org
To: linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cyeoh@au1.ibm.com
List-Id: linux-api@vger.kernel.org

Hello,

I have been reconsidering requirements and solutions brought up in my
post "How about allowing processes to expose memory for cross memory
attaching?". I now have a much clearer idea of what I want. I think
there is a need for publicly exposing process scoped
interfaces. Previous solutions such as cross memory attaching,
processes binding to ports, DBus and shared directories /run have
troubles with permissions, are not generic or work on a service
level. I suggest "public process scoped interfaces" as the solution,
that every process is give in it's own run directory in /proc for
publicly exposing services.

There is already an interface for cross memory attaching but the
interface has the same permissions constraints as ptracing. As well,
this solution is not generic and does not work for other kinds of
interfaces such as sockets or message queues. Furthermore, I believe
that this use case could be replaced by "public process scoped
interfaces" as follows. For example, in an MPI implementation a
process might create a file in /proc/self/run/openmp/queue (with only
user readable, writable permissions of course!) and map it into shared
memory. Then other processes would using that process's PID open the
file /proc/${PID}/run/openmp/queue, write to the file and then close
it. Unfortunately, that inflates the system call cost to three times
as much. Arguably, the cost could be mitigated by caching file
descriptors but it's likely that MPI implementations might continue
using the existing solution of cross memory attaching.

Many programs bind to ports to expose an interface for
communication. However, these interfaces are limited to internet
sockets. Moreover, multiple instances of the program have to fight
over the ports available. As well, there is no relation between the
process's PID and the port. Under "public process scoped interfaces"
any file interface can be used, each process has it's own interface
and there is an obvious way to find the interface from the PID.

Shared directories like /run and /tmp can let a process expose generic
file interfaces but there is no relation between the PID and exposed
interface. A process can create a file or directory such as
/tmp/${SERVICE}-${PID} but then that process is vulnerable to DOS
attacks by other users. Furthermore, the files are not removed on
process exit.

An object registry like DBus seems like a natural fit for this problem
but is oriented primarily towards services and not processes. There
are basically the same problems as with the shared directory
solution. As well, DBus is far too complicated when one just wants to
expose a socket interface. Moreover, there is no relation to the name
the process registers under and the PID.

A problem with "public process scoped interfaces" is that on process
exit the directory and all it's contents would be removed. This is
contrary to the semantics of rmdir which requires the directory to be
empty.

Final note, for a bit of speed and for letting /proc not be mounted
it could be convenient to create a system call, process_run_dir, that
takes a PID and opens the run directory for the process.

Thank you, Steven Stewart-Gallus

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
