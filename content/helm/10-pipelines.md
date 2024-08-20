---
title: 'Pipelines'
draft: false
weight: 100
series: ["Helm"]
series_order: 100
---
In Linux, pipelines are used to take the output of one command as the input of another command, which can also be done in helm.
# Key Points
- **Sequential Execution:** Functions are applied one after the other, with the output of one becoming the input of the next.
- **Flexibility:** You can chain multiple functions to achieve complex transformations.
- **Readability:** While powerful, excessive pipelining can reduce readability. Use it judiciously.
# Example Use Cases
**Formatting Image Names:**
```yaml
image: "{{ .Values.image.repository | upper | quote }}"
```

**Creating Unique Identifiers:**
```yaml
name: "{{ .Release.Name | lower | replace "-" "" }}"
```

**Complex Data Transformations:** While less common, pipelines can be used for more intricate data manipulations, such as converting lists into maps or vice versa.
# Cautions and Best Practices:
- **Error Handling:** Be mindful of potential errors. If one function fails, the entire pipeline might be affected.
- **Testing:** Thoroughly test your pipelines to ensure they produce the expected results.
- **Readability:** Prioritize clear and maintainable code. Break down complex pipelines into smaller steps if necessary.