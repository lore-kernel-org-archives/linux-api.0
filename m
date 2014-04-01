From: Steven Stewart-Gallus <sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org>
Subject: How about allowing processes to expose memory for cross memory
 attaching?
Date: Tue, 01 Apr 2014 04:41:29 +0000 (GMT)
Message-ID: <fa9efe3a24e39.533a4379@langara.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-disposition: inline
Content-language: en
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

A major limitation of process_vm_writev and process_vm_readv is that
they have the same permission constraints as ptrace. How about allowing
processes to expose memory for reading with process_vm_readv or
writing with process_vm_writev?

I think a good way of doing this might be to add flags to
process_vm_writev and process_vm_readv to make them temporarily
publish a vector of memory to another process until such memory is
read or written from with process_vm_writev or process_vm_readv once.
For example, one would invoke the process_vm functionality like so to
publish for reading the vector of memory in local_iov to the process
identified by pid:

if (-1 == process_vm_writev(pid,
                           local_iov, ARRAY_SIZE(local_iov),
                           NULL, 0,
                           PROC_VM_PUBLISH)) { // ...

The interface would be simpler if the functions blocked but then for
every EINTR handling loop there would need to be an EPERM loop on the
other side.

Finally, I'm not sure of what the semantics of that interface would be
in the presence of multithreading or shared memory. And, I'm not sure
how usable this interface would be for fast message passing which is
the whole intent of the process_vm functions (I'm using these
functions directly for my application and this interface seems like it
work fine with my application but I'm not sure it would work for
message passing libraries in general).

Thank you,
Steven Stewart-Gallus
