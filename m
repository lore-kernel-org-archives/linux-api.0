From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH V36 00/29] security: Add kernel lockdown functionality
Date: Thu, 18 Jul 2019 12:43:46 -0700
Message-ID: <20190718194415.108476-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Minor changes to the previous set, other than a significant rework of
the "Ignore acpi_rsdp kernel param" patch to deal with the early parsing
of that parameter under certain circumstances.
